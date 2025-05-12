output "lldap" {
  value = {
    admin_user = {
      admin = local.admin_user_password
    }
    endpoint = module.lldap.endpoint
  }
}