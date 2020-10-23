variable "app_env" {
  type        = string
  description = "Application name"
}

variable "release_version" {
  type        = string
  default     = "8.0.20"
  description = "Database version"
}

variable "name" {
  type        = string
  default     = "wordpress"
  description = "Database name"
}

variable "username" {
  type        = string
  default     = "wordpress"
  description = "Database username"
}

variable "password" {
  type        = string
  default     = "wordpress"
  description = "Database password"
}

variable "instance_class" {
  type        = string
  default     = "db.t2.medium"
  description = "Database instance class"
}

variable "private_subnets" {
  type        = list
  description = "Private subnets"
}

variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "sg_id_ingress" {
  type        = string
  description = "ID of the security group to use for filtering incomming connections"
}

