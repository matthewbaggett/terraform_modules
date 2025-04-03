variable "override_ami_id" {
  type        = string
  description = "The AMI to use for the worker nodes"
  default     = null
}
data "aws_ami" "override" {
  count = var.override_ami_id != null ? 1 : 0
  filter {
    name   = "id"
    values = [var.override_ami_id]
  }
}
data "aws_ami" "ubuntu" {
  count       = var.override_ami_id == null ? 1 : 0
  owners      = ["099720109477"] # Canonical
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  aws_ami = var.override_ami_id == null ? data.aws_ami.ubuntu[0] : data.aws_ami.override[0]
}
output "ami" {
  description = "The AMI used with this configuration"
  value       = var.override_ami_id == null ? data.aws_ami.ubuntu[0] : data.aws_ami.override[0]
}
