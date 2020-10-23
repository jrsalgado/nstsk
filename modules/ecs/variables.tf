variable "app_env" {
  description = "Application name"
}

variable "private_subnets" {
  type        = list
  description = "Private subnets"
}

variable "public_subnets" {
  type        = list
  description = "Public subnets"
}

variable "vpc_id" {
  description = "The VPC ID"
}

variable "ami_id" {
  description = "AMI ID"
}

variable "instance_type" {
  description = "Instance type"
  default     = "t2.large"
}

variable "asg_min_instance_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "asg_max_instance_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 2
}

variable "asg_desired_capacity" {
  description = "ASG desired capacity"
  type        = number
  default     = 2
}

variable "mysql_endpoint" {
  type        = string
  description = "MySQL endpoint"
}

variable "mysql_db_name" {
  type        = string
  description = "MySQL database name"
}

variable "mysql_db_username" {
  type        = string
  description = "MySQL username"
}

variable "mysql_db_password" {
  type        = string
  description = "MySQL password"
}

