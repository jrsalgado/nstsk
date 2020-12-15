variable "ami_name" {
  description = "Name of the AMI to use"
  type = string
} 

variable "ami_owner" {
  description = "Identifier of the AMI creator"
  type = string
  default = "099720109477"
}
