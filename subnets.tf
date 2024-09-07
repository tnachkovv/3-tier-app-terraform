resource "aws_subnet" "ep_public_subnet" {
  count             = var.subnet_count.public
  vpc_id            = aws_vpc.ep_vpc.id
  cidr_block        = var.public_subnet_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "ep_public_subnet_${count.index}"
  }
}

resource "aws_subnet" "ep_private_web_subnet" {
  count             = var.subnet_count.private
  vpc_id            = aws_vpc.ep_vpc.id
  cidr_block        = var.private_subnet_web_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "ep_private_web_subnet_${count.index}"
  }
}


resource "aws_subnet" "ep_private_app_subnet" {
  count             = var.subnet_count.private
  vpc_id            = aws_vpc.ep_vpc.id
  cidr_block        = var.private_subnet_app_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "ep_private_app_subnet_${count.index}"
  }
}

resource "aws_subnet" "ep_private_db_subnet" {
  count             = var.subnet_count.private
  vpc_id            = aws_vpc.ep_vpc.id
  cidr_block        = var.private_subnet_db_cidr_blocks[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "ep_private_db_subnet_${count.index}"
  }
}
