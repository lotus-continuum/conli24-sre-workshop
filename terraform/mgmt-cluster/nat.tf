resource "aws_eip" "conli24_nat_ip" {
  vpc = true

  tags = {
    Name = "conli24-nat-ip"
  }
}

resource "aws_nat_gateway" "conli24_nat_gateway" {
  allocation_id = aws_eip.conli24_nat_ip.id
  subnet_id     = aws_subnet.mgmt_public_eu_west_1a.id

  tags = {
    Name = "conli24-nat-gateway"
  }

  depends_on = [aws_internet_gateway.conli24_internet_gateway]
}