/*
resource "docker_plugin" "efs" {
  depends_on = [module.efs_file_system]
  name       = var.image_efs_plugin
  alias      = local.alias
  enabled    = true
  env        = local.rexray_env
  grant_permissions {
    name  = "network"
    value = ["host"]
  }
  grant_permissions {
    name  = "mount"
    value = ["/dev"]
  }
  grant_permissions {
    name  = "allow-all-devices"
    value = ["true"]
  }
  grant_permissions {
    name  = "capabilities"
    value = ["CAP_SYS_ADMIN"]
  }
  lifecycle {
    create_before_destroy = false
  }
}*/