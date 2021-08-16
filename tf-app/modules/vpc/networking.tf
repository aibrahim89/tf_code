resource "aws_vpc" "main" {
  cidr_block       = "${var.vpc_cider}"
  instance_tenancy = "${var.tenancy}"

  tags = {
    Name = "test-vpc-16082021"
  }
}

resource "aws_subnet" "main" {
  vpc_id     = "${var.vpc_id}"
  cidr_block = "${var.subnet_cider}"

  tags = {
    Name = "Main"
  }
}