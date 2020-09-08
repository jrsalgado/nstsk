output "ami_ubuntu_18_04" {
  value = data.aws_ami.latest_ubuntu.image_id
  description = "Will output the latest AMI for latest ubuntu 18.04 hvm ebs"
}