provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}


data "http" "my_ip" {
  url = "http://ipv4.icanhazip.com"
}

module "ami" {
  source = "../../modules/ami"
}

module "wordpress" {
  source               = "../../modules/wordpress"
  ami                  = module.ami_ubuntu_18_04
  app_env              = var.app_env
  allow_ssh_cidr_block = "${chomp(data.http.my_ip.body)}/32"
  private_subnets      = data.terraform_remote_state.cloud.outputs.private_subnets.*.id
}
