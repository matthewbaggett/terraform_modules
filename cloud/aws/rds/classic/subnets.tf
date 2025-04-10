variable "aws_subnets_ids" {
  description = "Pass an aws_subnets data object to the module"
  type =  list(string)
}
data "aws_subnets" "subnets" {
  filter {
    name   = "subnet-id"
    values = var.aws_subnets_ids
  }
}
resource "aws_db_subnet_group" "sg" {
  name       = lower(join("-", [var.instance_name, "subnet-group"]))
  subnet_ids = data.aws_subnets.subnets.ids
  tags = merge(
    try(var.application.application_tag, {}),
    {
      Name = "${var.instance_name} Subnet Group"
    }
  )
}