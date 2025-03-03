module "nextcloud" {
  source                = "../../docker/service"
  enable                = var.enable
  stack_name            = var.stack_name
  service_name          = "nextcloud"
  image                 = "nextcloud:stable"
  networks              = [module.network]
  ports                 = var.ports
  mounts                = var.mounts
  placement_constraints = var.placement_constraints
  environment_variables = {
    POSTGRES_HOST       = module.postgres.service_name
    POSTGRES_USER       = module.postgres.username
    POSTGRES_PASSWORD   = module.postgres.password
    POSTGRES_DB         = module.postgres.database
    REDIS_HOST          = module.redis.service_name
    REDIS_HOST_PASSWORD = module.redis.auth
    #NEXTCLOUD_ADMIN_USER     = random_pet.admin_user.id
    #NEXTCLOUD_ADMIN_PASSWORD = nonsensitive(random_password.admin_password.result)
    NEXTCLOUD_DATA_DIR = "/mnt/data"
    #NEXTCLOUD_UPDATE         = false
    #NEXTCLOUD_INIT_HTACCESS  = true
    NC_setup_create_db_user = false
  }
  converge_enable = false # @todo: Implement a healthcheck and change this.
  start_first     = false
}
resource "random_pet" "admin_user" {
  length    = 2
  separator = ""
}
resource "random_password" "admin_password" {
  length  = 32
  special = false
}