locals {
  config = {
    server_url          = "http://${var.domain}"
    listen_addr         = "0.0.0.0:8080"
    metrics_listen_addr = "0.0.0.0:9090"
    grpc_listen_addr    = "0.0.0.0:50443"
    grpc_allow_insecure = false
    private_key_path    = "/var/lib/headscale/private.key"
    noise = {
      private_key_path = "/var/lib/headscale/noise_private.key"
    }
    prefixes = {
      #v6 = "fd7a:115c:a1e0::/48"
      v4         = "100.64.0.0/10"
      allocation = "sequential"
    }
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
    database = {
      type = "postgres"
      postgres = {
        host = module.postgres.service_name
        port = 5432
        name = module.postgres.database
        user = module.postgres.username
        pass = module.postgres.password
      }
    }

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
    policy = {
      path = ""
    }

    # DNS
    dns = {
      nameservers = ["1.1.1.1"]
      magic_dns   = true
      base_domain = "ts.${var.domain}"
    }

    unix_socket            = "/var/run/headscale.sock"
    unix_socket_permission = "0770"

    logtail = {
      enabled = false
    }
    randomize_client_port = false
  }
}