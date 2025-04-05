data "http" "docker_asc" {
  url = "https://download.docker.com/linux/ubuntu/gpg"
}
resource "random_password" "salt" {
  count            = var.service_account_password == null ? 0 : 1
  length           = 8
  special          = true
  override_special = "!@#%&*()-_=+[]{}<>:?"
}
resource "htpasswd_password" "hash" {
  count    = var.service_account_password == null ? 0 : 1
  password = var.service_account_password
  salt     = random_password.salt[0].result
}
locals {
  advertise_address = var.advertise_address != null ? "--advertise-addr ${var.advertise_address}" : ""
  manager_address   = var.manager_address
  default_address_pool_cidr = join(" ", [
    "--default-addr-pool ${var.default_address_pool_cidr}",
  ])
  is_first_manager = var.manager_token == null && var.worker_token == null
  is_manager       = var.manager_token != null
  is_worker        = var.worker_token != null
  init_args = join(" ", [
    local.advertise_address,
    local.default_address_pool_cidr
  ])
  ubuntu_codename = "noble" // @todo derive this from the ami
  ubuntu_arch     = "amd64" // @todo derive this from the ami

  docker_ingress_cidr = "10.200.0.0/16"

  docker_daemon_config = {
    "labels" = var.extra_docker_labels
  }
  cloud_config = {
    hostname = var.hostname
    groups   = ["sudo", "docker"]
    users = [
      {
        name                = var.service_account_username,
        ssh_authorized_keys = var.service_account_public_ssh_keys,
        hashed_passwd       = var.service_account_password != null ? htpasswd_password.hash[0].sha512 : null
        lock_passwd         = var.service_account_password == null ? true : false
        sudo                = "ALL=(ALL) NOPASSWD:ALL"
        shell               = "/bin/bash"
        groups              = ["sudo", "docker"]
      }
    ]
    write_files = [
      {
        path        = "/etc/apt/sources.list.d/docker.list"
        owner       = "root:root"
        permissions = "0o644"
        encoding    = "base64"
        content     = base64encode("deb [arch=${local.ubuntu_arch} signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu ${local.ubuntu_codename} stable\n")
        }, {
        path        = "/etc/apt/keyrings/docker.asc"
        owner       = "root:root"
        permissions = "0o600"
        encoding    = "base64"
        content     = data.http.docker_asc.response_body_base64
        }, {
        path        = "/etc/docker/daemon.json"
        owner       = "root:root"
        permissions = "0o644"
        content     = jsonencode(local.docker_daemon_config)
        }, {
        path    = "/etc/sysctl.d/50-docker-tuning.conf"
        owner   = "root:root"
        content = file("${path.module}/docker-tuning.conf")
        }, {
        path    = "/etc/sysctl.d/50-disable-ipv6.conf"
        owner   = "root:root"
        content = <<EOF
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1
EOF
        }, {
        path    = "/etc/security/limits.conf"
        owner   = "root:root"
        content = "* - nofile 64000\n"
        }, {
        path  = "/etc/cron.d/cleanup_docker_nodes"
        owner = "root:root"
        content : "#*/5 * * * * root docker node rm $(docker node ls | grep Down | cut -f1 -d' ' )\n"
        }, {
        path    = "/etc/cron.d/cleanup_docker_system_prune"
        owner   = "root:root"
        content = "0 0 * * * root docker system prune -af --volumes\n"
        }, {
        path    = "/etc/cron.d/cleanup_docker_rebalance"
        owner   = "root:root"
        content = "#*/15 * * * * root docker service ls -q | shuf |xargs -i docker service update {} --force\n"
      }
    ]
    packages = sort(concat([
      "apt-transport-https",
      "ca-certificates",
      "software-properties-common",
      "gnupg-agent",
      "btop", "htop",
      "docker.io",
      "openssh-server",
      "jq",
      "net-tools",
      "curl", "wget",
    ], var.extra_apt_packages))
    package_update  = true
    package_upgrade = true
    runcmd = compact(concat([
      # OpenSSH Port in UFW
      "ufw allow ssh",
      # Jostle NTPd to do its thing
      "service ntp stop",
      "ntpd -gq",
      "service ntp start",
      # Enable SSH daemon
      "echo 'Enabling SSH'",
      "systemctl enable ssh",
      "systemctl start ssh",

      # Stop docker
      "echo 'Stopping Docker'",
      "systemctl stop docker",

      # Enable and start Docker
      "echo 'Starting Docker'",
      "systemctl enable docker",
      "systemctl start docker",

      # Remove the default ingress network
      "yes | docker network rm ingress",
      "docker network create --driver overlay --ingress --subnet=${local.docker_ingress_cidr} --gateway=${cidrhost(local.docker_ingress_cidr, 1)} ingress",

      # Remove unsupported keys (Terraform can't generate DSA and ED25519 keys)
      "echo 'LS0tLS1CRUdJTiBFQyBQUklWQVRFIEtFWS0tLS0tCk1HZ0NBUUVFSEtZOTJxQmpacCt0SHFXZ0IzWWljK1NxbEJ5WjBmRVF0cGw1cXhPZ0J3WUZLNEVFQUNHaFBBTTYKQUFUQ3EwR29BdXZvQlJiZ2tpZ3J2cHhvSDhTRnRoMU5YQlJKRmRWbEU4VzNPb0tkRGI4SmIyMUN0b0szRVNQLwpmV1kyQzk5WHFYcFp5Zz09Ci0tLS0tRU5EIEVDIFBSSVZBVEUgS0VZLS0tLS0K' | base64 -d > /etc/ssh/ssh_host_ecdsa_key",
      "echo 'LS0tLS1CRUdJTiBSU0EgUFJJVkFURSBLRVktLS0tLQpNSUlKS2dJQkFBS0NBZ0VBeWtnZnRYalFlUmRUWlFxWm1hcU5oKzZLNjYrSWhPK2xCQ3FVVzdKRUZobldaS2c1CldzT3dzcXZlc0RuRDdlWXIrRFp1c3dvVGNrSTRadUNXYkwwVGFDeVlDekZCZHBFbGZnWktodEFiOHBmKyt6WXMKMWpkamZLaEtMc3BBMWF3UDRpT0crYnJaQ1NiYTVKK1VFR0dzVlBEK1RVcUMwTDZTZVQyRDlEQjl2YVdSeHJKUgpmelVRL1kxdmQvRG9mZEFaZlJ1ZGkyLzU0djFXcFVvMUplVCtmYUFKRWdOWkcya21qQ0pSY2hoM2toYjBHc0xECkU1ZUJiOGFsenR0TmRnUlhSSUFEK2Fsb2JOOWpjRm5DVldyZGJWdE5CWmMza2NGNjg2dkt1MFhCV3h5bGtoY2EKR3I3SlhLb1JhRzREdkVEa3NQMmZEZ2luTXFoMHRTMlBGOFlaZWZkdVNWbUdEbWlSSGlPNVJyYlpnQTBmM0dSTwpwWVExVjE3Q1dyN1ZJZm9mR2hmOThZZnpLUnZDUVhyN1R6ODV6UDVHN1cxRFNmSHpQY25LQ2lGbTJxZ2YwczdLCllXR1ZCanJVVEFZRmtXMlZ6V2NZUGZwcHVYZmM1dHRkcGR2eWVGMjg5dGZkS3gxa1dpNTZkbndIcGRybTZEaGMKVk55cU5IaHNZRFgzVTg4ck9FaHpqdGcyb2tlRkhwck9PL1RuMG0zV2MwZEJOL3NqVjIyNU4xR08rd0xIOTkwTwpDMHhrNUZQVENMR1Q5aGdLbEVKaGdTVm03RmpQOFRBTmR1K2RpUzQ3cDZlSGx1c3pEb0ZtdTdFWUhHdUk3K2ZqCmhCWjR2NEN1WmhzZG5PM1pqRHJOR1c5WXU0dE9PQ2hUeG5KR0xRSFNlamZVWHdxQXNCQ01naW10Zm5VQ0F3RUEKQVFLQ0FnRUFxQSs0V0p2aUNWbDU3aThhWXZPeTEwYzNvSTJjaldaVjRkcEduTkRGaE44K295NnBTR0hpQXZDTQoramxrTWRuVW1rc1BPaTJhN29sYU53OU5xMWFFTXo4cHE5TG1vczRCS20ycnFjcHFEZXArN05TYjkvYlk3NDhhCjR6a2pHT1AxNWxyQ0grWS93RHpLREwwUTFYTnhMTGwxYjE0Q3hkQXYvZzgvL0xmMUlJWFpVZzZCYTRENWRzLzEKMXQ4UEtzaWxCSzdXL0N5eW53Y0E0QitCZk5SL0pIeThUSHovb2FpQllGaDY5cUtoWlgwd25yTkdSSmJSOGI1SApzRS9BVWRkVmNoSXlPMUdtOHgyK2ptL2s1L2I3dFludnVqOWk2ZlNvWko5TXRyOUQ0S0V5WnVoT3hmM1JhdTNaCnZMdjYyb1BIL2MwYVF4eXBYWXRjTzlONFdiWTdId0ZOUGM0VDNOdnA3aVRQcmNaWlNEbDdrUys0ME5iWDYrTEUKeVhaS1ZQUWRONWxBei91YU9ISDkxT2Q1RjM3NTNVTUVCTDVZQmllSG9rem5xQlB4Y1NQWWwwcDMyU3FyNkVTdApUQWxsNG96MXpDcytuc3VqQ1FyN2NSRmxtOE12a0tyMWtPOVo0bjBTdzBDLzZVOWo1VFZkRmZkbWljUWxCcCswCnlocGM0REoza3ErWU84WEdHcXJrSHdvZVp6NnlxUE1hWVVBY1d3RU0zN2ZZUFc0SzVIWFdRbVVDWFg3a2wzWUYKcmIvUHNkSUx0TFZTMXhZTitGUVlYbExtMFVyM1RydGRHTjFGUU1WdDc1SnpmMGdtQ2RnSFA3RGN3Z0djQW05UQpaNFpMWStpK0xYd0o4YUlPTTFyTFB4RHJSTkZzZklJNjV4YlYzYTVrSmxIWUtsVlFBWUVDZ2dFQkFOSjczQjN0CkRINVVkUVU0ZHUrRTdYZnJsQlhUL0hDeWZqOU9xWVdFWnJWVzV2UzlwRW15MXhKLzRjU1kwbmVoV1BVK21BZ0IKMXRZalJyQ005Y3ZycDhtNEJkNUkrOWVhSS9hK0FFdjhtSTNvaTc5UkwwY1A5VThzaFBYeUNNNEZ2VlR2eVczQQpmZDVkdTlmZUFFYlBVdTNEcG1neTdyd21iWTdJcTVNU3kycHVvMDZURGJYcHV6Wmg1cHBtQjE5aDFjbWt2Z01HCklEUHJ2ZEpTZjl1MUJYdS9nWGVFckdCQmhKSm5IOFV4QkZtbitxUk9YTFNJTUpvRXJCTUM2SDQ1eWl4RE9HKzUKVUJwV2pJTGJuMk04eGozZ1hLbjgyU2p3NWdPY041dmxwM2lYU3VJZjI1L1hGdUJzOEkweFVPanY2TStNUWtQbgpMSnlHZzlXNkcyMjFDN0VDZ2dFQkFQWUdOS1hrWTAzZVpPQ1F6YmdlMi9oNVZmait6eTNraUtObkhCMFBXSVBXCnJDbS9Mb0NlRnBIZ1BScFNOTUJlRmtOaDN3bG5BTnpnMWRHREErWXR3a2QxV3NDY0tONGF6Wk9McHg4czV0Z1AKQVlvOUdEbUl0QlJiYnpLWkYwZ202dldxUHN2cllINVArSUhVOUpiUm1mWURUSXlaRUo4SHNKWVJPWVFMdmIyUgpxNG0vOUN2M3B0MzlnemRPR3ZiOHVNVlFxNytOL0U0WW5QWG9EMXdDbG00bUphVmp2eHhGdU5RVTFDQkdpZ215CmJkVHFlTStYbG1vaWFvZ3FaMlNOTWs0OWJ2akdyYittZTIzYVA1MVEvUkNNK25NdnVkSVhuNE1ZTDdBWGVyOGwKN0M1cGtaZW5GSEFQaG1GbDJrQUR3NExqMktkRzkxYlQyZ21BRHEwdGhBVUNnZ0VBUUxTbzkxNHZNQXJncW9rdwpMdlBMV01sSURlbk1PZ3oxT0pzRERET21xMnFhdDNReE5DTFJjVE4xQVU0RnJaY2hWTXM0UzRYZE9KbEJtdmJLCmZUVGxzT0pzazJnV1c3SmNDZmRnK2ZzZUhzbjFaQXdlSDVkdFR6aWRhMHBMb0tJdEVSWmg4dVp4QzFIL2RCNGcKTWFSOGx2RkZqOVRRaFhDK3oxMHJPWnhXZ2xLZXk0SHpmZy9yYUkxeUtkYmh2MVhCTmlyNTZzNFFTa1hYWmZmTQpySXNhczI4czZzUVRoY2UrYkk5ZE9lNldxc1UwRFJ5MTdSM002eHd5bGVtWDlXM29rL0RhUWFaVFZMVjBucW5MCmR1TnhBZ2FlRmZmUC9vRUlCT1lhUmtlMFV5TVhkeXBhQnVwRmN4cXFYSTFqbFNoamhxSlVvTEZKaXBqam9HbUYKRXhYTUVRS0NBUUVBaDhnQkFwVzhJTnZlL1BtdU1ESUg0V2pHQkRoTmk5eVhkT2VSWXBCM243dTVKUWs0MXc5cApFWFdiQTQzZlExUXFJV0pBd0dXeTJqVFVqVjhycGJ3WGYyekxlNFkwSC9EWENObUlrUEl0TFkyS29ncjU5YmIyCi9FMUNYOENTVXVYM3cwSUVpbk1MdkdyU2tvVS93SVZKM2JjUVpvQ0w1ZGxPb21RN1JCOWV4dU5Bc3pQWHhQUlgKaWlsQ1pDR2RURGRLbXN2ZEhrbDB1SDFwRTJiU0kwdmlUa1NMZm01QXFZL3BaRk5paDdXbXRaZGVlcVkxcXd6VQpuUnNGaE1VeWJ4Sm1jendBcFJpeUNCWVFCUjd4QVJnVHN6QzdnUnNVQ1ZtMFZadmhwZVF2Z0pPamVESVhnb1ZhCkNFYnBPWlFIRWxHQmRCbmdGdUpaMi9mc1hGWHF3N1ZkS1FLQ0FRRUFqUnd4M2FWYjgwQ2xqd0FqKzdjMlRmUm8Kb0VqTnJQWm9vNHlVelY0NUROeVBINjNwZXRkRnJJTkphMmg0MTVvS0p1OTg5TFRrc1R2dllscUtQMDluVlhiVQorZ1hQNjB3QnpzR1JJTTd3Y3l2WEt2d29ybTFGRW9RWG1TMkdBUUpLQlZvUkFQWmtVYk9yQXJTKzNDUFZXOVB2CjBkWjByOTN1ZmxYR0lzRkRpYUVPMHJPMkxseXBiM09qbzI2ZGNIUVpuTDBhYm9iQk1xQmVlai9KUGRwRkhxUmUKd0NuUXB5bkpKWjJGOGtYKzV4ZjFaYXN5RmZVUDhPSG1xODE3YkZ0V25GcGhFaXUwbUZ0djlRejhuS2EyZ0xuRQpDaVlnOEFJbU9mZnVKYlYxYXc1THZ6ck1hbER5K3J6R05MOFFoMGw3b0lXYTVLdVZIMUlzK3J6dXhyVGpUUT09Ci0tLS0tRU5EIFJTQSBQUklWQVRFIEtFWS0tLS0tCg==' | base64 -d > /etc/ssh/ssh_host_rsa_key",
      "sed -i -e 's|#HostKey /etc/ssh/ssh_host_rsa_key|HostKey /etc/ssh/ssh_host_rsa_key|' /etc/ssh/sshd_config",
      "sed -i -e 's|#HostKey /etc/ssh/ssh_host_ecdsa_key|HostKey /etc/ssh/ssh_host_ecdsa_key|' /etc/ssh/sshd_config",
      "rm /etc/ssh/ssh_host_dsa_key /etc/ssh/ssh_host_ed25519_key",
      "sed -i -e 's|#HostKey /etc/ssh/ssh_host_dsa_key||' /etc/ssh/sshd_config",
      "sed -i -e 's|#HostKey /etc/ssh/ssh_host_ed25519_key||' /etc/ssh/sshd_config",
      "sed -i 's|#MaxSessions .*|MaxSessions 500|' /etc/ssh/sshd_config",
      "systemctl restart ssh",

      # Bump sysctl to reload since we altered /etc/sysctl.d/*
      "sysctl --system",

      # Prefer IPv4 over IPv6
      "sh -c \"echo 'precedence ::ffff:0:0/96 100' >> /etc/gai.conf\"",

      # Wait for Docker to start
      "echo 'Waiting for Docker to start'",
      "sleep 5",

      # Remove ingress network
      "yes | docker network rm ingress",

      # Create ingress network with a wider CIDR
      local.is_first_manager ? "docker network create --driver overlay --ingress --subnet=${local.docker_ingress_cidr} --gateway=${cidrhost(local.docker_ingress_cidr, 1)} ingress" : null,

      # If this is our first manager, create our swarm and then generate our worker and manager tokens
      local.is_first_manager ? "docker swarm init ${local.init_args}" : null,
      # If this is a manager, join the swarm
      local.is_manager ? "docker swarm join --token ${trimspace(var.manager_token)} ${trimspace(local.manager_address)}" : null,
      # If this is a worker, join the swarm
      local.is_worker ? "docker swarm join --token ${trimspace(var.worker_token)} ${trimspace(local.manager_address)}" : null,

      # Install Xen Orchestra Linux Guest Tools
      "mkdir -p /tmp/linux-guest-tools",
      "wget -O /tmp/linux-guest-tools/LGT.tar.gz https://downloads.xenserver.com/vm-tools-linux/8.4.0-1/LinuxGuestTools-8.4.0-1.tar.gz",
      "cd /tmp/linux-guest-tools; tar -xzf LGT.tar.gz",
      "sudo /tmp/linux-guest-tools/LinuxGuestTools-8.4.0-1/install.sh -n",
    ], var.startup_scripts))
    final_message = "Cloud-init is complete! Up after $UPTIME seconds."
  }

  config = "#cloud-config\n# See documentation for more configuration examples\n# https://cloudinit.readthedocs.io/en/latest/reference/examples.html\n\n${yamlencode(local.cloud_config)}"
}
data "cloudinit_config" "config" {
  gzip          = false
  base64_encode = false
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content      = local.config
  }

  # Create a file when cloud-init is complete
  part {
    filename = "/var/run/cloud-init-complete"
    content  = "The presence of this file indicates that cloud-init has completed"
  }
}