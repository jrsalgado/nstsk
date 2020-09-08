variable "instance_type" {
  description = "Provide instance type by default t2.micro"
  default     = "t2.micro"
}

variable "key_name" {
  description = "Key name to access using ssh"
}

variable "ami" {
  description = "Provide the AMI to create autoscaling group"
}

variable "app_env" {
  description = "For multiple environment"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "vpc_elb_subnets" {
  type        = "list"
  description = "A list of subnet IDs to attach to the ELB"
}

variable "size" {
  description = "Size of the autoscaling group"
  default     = "1"
}

variable "vpc_subnets" {
  type        = "list"
  description = "A list of subnet IDs to launch resources in"
}

variable "allow_ssh_cidr_block" {
  description = "CIDR to access through ssh, preferred your IP address/32 or use an internal CIDR for VPN"
}