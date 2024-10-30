resource "aws_internet_gateway" "conli24_internet_gateway" {
  vpc_id = aws_vpc.conli24_vpc.id

  tags = {
    Name = "conli24-internet-gateway"
  }
}
