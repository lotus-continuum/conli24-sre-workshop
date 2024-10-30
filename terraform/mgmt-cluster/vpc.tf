# VPC for all subnets
resource "aws_vpc" "conli24_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "conli24-vpc"
  }
}
