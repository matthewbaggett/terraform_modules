module "mysql" {
  source                = "../mysql"
  enable                = var.enable
  stack_name            = var.stack_name
  database              = "seafile"
  username              = "seafile"
  networks              = [module.network]
  data_persist_path     = "${var.data_persist_path}/mysql"
  placement_constraints = var.placement_constraints
  ports                 = var.mysql_ports
}