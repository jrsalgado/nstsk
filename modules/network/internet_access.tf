resource "aws_internet_gateway" "gateway" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix} - Internet Gateway"
  }
}

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gateway.id
  }

  tags = {
    Name = "${var.prefix} - FrontEnd Subnet"
  }
}

resource "aws_route_table_association" "route_table_public_association" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets.*.id, count.index)
  route_table_id = aws_route_table.route_table_public.id
  depends_on     = [aws_route_table.route_table_public]
}

resource "aws_eip" "nat" {
  count = length(aws_subnet.public_subnets)
  vpc   = true
  tags = {
    Name = "${var.prefix} - Internet Access EIP - ${count.index + 1}"
  }
}
