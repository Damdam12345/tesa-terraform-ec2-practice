# Get availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# Reference existing VPC
data "aws_vpc" "existing" {
  id = var.vpc_id
}

# Reference existing Internet Gateway
data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

# Reference existing Route Table
data "aws_route_table" "existing" {
  route_table_id = "rtb-0d9918b937b3b41e9"
}

