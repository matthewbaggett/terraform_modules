locals {
  config = {
    server_url          = var.domain
    listen_addr         = "0.0.0.0:8080"
    metrics_listen_addr = "0.0.0.0:9090"
    grpc_listen_addr    = "0.0.0.0:50443"
    grpc_allow_insecure = false
    private_key_path    = "/var/lib/headscale/private.key"
    noise = {
      private_key_path = "/var/lib/headscale/noise_private.key"
    }
    ip_prefixes = [
      #"fd7a:115c:a1e0::/48",
      "100.64.0.0/10",
    ]
    derp = {
      server = {
        enabled          = false
        region_id        = 999
        region_code      = "headscale"
        region_name      = "Headscale Embedded DERP"
        stun_listen_addr = "0.0.0.0:3478"
      }
      urls = [
        "https://controlplane.tailscale.com/derpmap/default",
      ]
      paths               = []
      auto_update_enabled = true
      update_frequency    = "24h"
    }
    disable_check_updates             = false
    ephemeral_node_inactivity_timeout = "30m"
    node_update_check_interval        = "10s"

    # Database bits
    db_type = "postgres"
    db_host = module.postgres.service_name
    db_port = "5432"
    db_name = module.postgres.database
    db_user = module.postgres.username
    db_pass = module.postgres.password

    # Lets encrypt bits
    #acme_url = "https://acme-v02.api.letsencrypt.org/directory"
    #acme_email = var.email
    #tls_letsencrypt_hostname = var.domain
    #tls_letsencrypt_cache_dir = "/var/lib/headscale/acme"
    #tls_letsencrypt_challenge_type = "HTTP-01"
    #tls_letsencrypt_listen = ":http"
    tls_cert_path = ""
    tls_key_path  = ""

    # Logs
    log = {
      level  = "info"
      format = "text"
    }

    # ACL
    acl_policy_path = ""

    # DNS
    dns_config = {
      override_local_dns = true
      nameservers        = ["1.1.1.1"]
      magic_dns          = true
      base_domain        = var.domain
    }

    unix_socket            = "/var/run/headscale.sock"
    unix_socket_permission = "0770"

    logtail = {
      enabled = false
    }
    randomize_client_port = false
  }
}