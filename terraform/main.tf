provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = false
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_route_table_association" "private_rt_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Create S3 VPC Endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id          = aws_vpc.my_vpc.id
  service_name    = "com.amazonaws.us-east-1.s3"
  route_table_ids = [aws_route_table.private_rt.id]
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "s3-vpc-endpoint"
  }
}
