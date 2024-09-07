resource "aws_vpc" "ep_vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "ep_vpc"
  }
}

resource "aws_internet_gateway" "ep_igw" {
  vpc_id = aws_vpc.ep_vpc.id
  tags = {
    Name = "ep_igw"
  }
}