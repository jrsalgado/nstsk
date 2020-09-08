resource "aws_nat_gateway" "nat" {
  count         = length(aws_subnet.public_subnets)
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public_subnets.*.id, count.index)
  depends_on    = [aws_internet_gateway.gateway]
  tags = {
    Name = "${var.prefix} - ${count.index + 1}"
  }
}

resource "aws_route_table" "route_table_private" {
  count  = length(aws_nat_gateway.nat)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = element(aws_nat_gateway.nat.*.id, count.index)
  }

  tags = {
    Name = "${var.prefix} - BackEnd Subnet - ${count.index + 1}"
  }
}

resource "aws_route_table_association" "route_table_private_association" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.route_table_private.*.id, count.index)
  depends_on     = [aws_route_table.route_table_private]
}
