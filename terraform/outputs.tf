output "vpc_id" {
  value = aws_vpc.my_vpc.id
}

output "subnet_id" {
  value = aws_subnet.private_subnet.id
}

output "ec2_instance_id" {
  value = aws_instance.private_ec2.id
}

output "s3_vpc_endpoint_id" {
  value = aws_vpc_endpoint.s3_endpoint.id
}
