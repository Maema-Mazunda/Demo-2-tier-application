resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

# create internet gateway and attach it to the vpc
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vp

  tags = {
    Name = "${var.project_name}-igw"
  }
}
