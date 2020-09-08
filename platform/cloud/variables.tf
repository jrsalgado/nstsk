# Network
variable "vpc_cidr" {
  description = "CIDR for the VPC"
}

variable "public_subnet_cidrs" {
  description = "CIDRs for the public subnets"
}

variable "private_subnet_cidrs" {
  description = "CIDRs for the private subnets"
}
