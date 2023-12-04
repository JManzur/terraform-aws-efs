data "aws_vpc" "this" {
  id = var.vpc_id
}

locals {
  vpc_cidr = data.aws_vpc.this.cidr_block
}