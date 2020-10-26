variable "aws_region" {
  description = "AWS region to deploy"
}

variable "aws_profile" {
  description = "AWS Profile"
}

variable "app_env" {
  description = "Application environment name"
  default = "dev"
}
