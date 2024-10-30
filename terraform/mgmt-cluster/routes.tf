resource "aws_route_table" "conli24_private_route_table" {
  vpc_id = aws_vpc.conli24_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.conli24_nat_gateway.id
  }

  tags = {
    Name = "conli24_private_route_table"
  }
}

resource "aws_route_table" "conli24_public_route_table" {
  vpc_id = aws_vpc.conli24_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.conli24_internet_gateway.id
  }

  tags = {
    Name = "conli24_public_route_table"
  }
}

resource "aws_route_table_association" "mgmt_private_eu_west_1a" {
  subnet_id      = aws_subnet.mgmt_private_eu_west_1a.id
  route_table_id = aws_route_table.conli24_private_route_table.id
}

resource "aws_route_table_association" "mgmt_public_eu_west_1a" {
  subnet_id      = aws_subnet.mgmt_public_eu_west_1a.id
  route_table_id = aws_route_table.conli24_public_route_table.id
}
