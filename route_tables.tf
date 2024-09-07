resource "aws_route_table" "ep_public_rt" {
  vpc_id = aws_vpc.ep_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ep_igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = var.subnet_count.public
  route_table_id = aws_route_table.ep_public_rt.id
  subnet_id      = 	aws_subnet.ep_public_subnet[count.index].id
}

resource "aws_route_table" "ep_private_rt" {
  vpc_id = aws_vpc.ep_vpc.id
}

resource "aws_route_table" "ep_private_rt_db" {
  vpc_id = aws_vpc.ep_vpc.id
}


resource "aws_route_table_association" "private_web" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.ep_private_rt.id
  subnet_id      = aws_subnet.ep_private_web_subnet[count.index].id
}


resource "aws_route_table_association" "private_app" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.ep_private_rt.id
  subnet_id      = aws_subnet.ep_private_app_subnet[count.index].id
}

resource "aws_route_table_association" "private_db" {
  count          = var.subnet_count.private
  route_table_id = aws_route_table.ep_private_rt_db.id
  subnet_id      = aws_subnet.ep_private_db_subnet[count.index].id
}
