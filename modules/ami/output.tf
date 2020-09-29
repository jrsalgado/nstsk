output "ami_id" {
  value       = data.aws_ami.latest_ami.image_id
  description = "ID of the requested AMI"
}
