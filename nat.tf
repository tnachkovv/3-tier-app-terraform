resource "aws_nat_gateway" "ep_nat_gateway" {
  allocation_id = aws_eip.ep_nat_eip.id
  subnet_id     = aws_subnet.ep_public_subnet[0].id
}

resource "aws_route" "ep_private_route" {
  route_table_id         = aws_route_table.ep_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.ep_nat_gateway.id
}