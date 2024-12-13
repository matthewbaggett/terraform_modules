variable "aws_subnets" {
  description = "Pass an aws_subnets data object to the module"
  type = object({
    ids = list(string)
  })
}
data "aws_subnets" "subnets" {
  filter {
    name   = "subnet-id"
    values = var.aws_subnets.ids
  }
}
resource "aws_db_subnet_group" "sg" {
  name       = "${var.instance_name}-subnet-group"
  subnet_ids = data.aws_subnets.subnets.ids
  tags = merge(
    try(var.application.application_tag, {}),
    {
      Name = "${var.instance_name} Subnet Group"
    }
  )
}