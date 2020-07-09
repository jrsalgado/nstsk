output "vpc_main" {
  value       = aws_vpc.main
  description = "Is the main VPC"
}

output "public_subnets" {
  value       = aws_subnet.public_subnets
  description = "Is the list of publics subnets"
}

output "private_subnets" {
  value       = aws_subnet.private_subnets
  description = "Is the list of privates subnets"
}
