resource "aws_subnet" "mgmt_private_eu_west_1a" {
  vpc_id            = aws_vpc.conli24_vpc.id
  cidr_block        = "10.0.0.0/24"
  availability_zone = "eu-west-1a"

  tags = {
    "Name" = "mgmt_private_eu_west_1a"
  }
}

resource "aws_subnet" "mgmt_public_eu_west_1a" {
  vpc_id                  = aws_vpc.conli24_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "eu-west-1a"
  map_public_ip_on_launch = true

  tags = {
    "Name" = "mgmt_public_eu_west_1a"
  }
}

