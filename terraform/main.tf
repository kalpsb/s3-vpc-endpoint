provider "aws" {
  region = var.aws_region
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = var.vpc_cidr
}

# Create Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = var.private_subnet_cidr
  map_public_ip_on_launch = false
}

# Create Route Table for Private Subnet
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
  service_name    = "com.amazonaws.${var.aws_region}.s3"
  route_table_ids = [aws_route_table.private_rt.id]
  vpc_endpoint_type = "Gateway"

  tags = {
    Name = "s3-vpc-endpoint"
  }
}

# Create EC2 Instance in Private Subnet
resource "aws_instance" "private_ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.private_subnet.id
  key_name      = var.key_name
  tags = {
    Name = "PrivateEC2"
  }
}
