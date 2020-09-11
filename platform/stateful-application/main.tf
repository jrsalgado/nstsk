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
  app_env              = var.app_env
  key_name             = var.key_name
  ami                  = module.ami.ami_ubuntu_18_04
  allow_ssh_cidr_block = "${chomp(data.http.my_ip.body)}/32"
  vpc_id               = data.terraform_remote_state.cloud.outputs.vpc_main.id
  public_subnets       = data.terraform_remote_state.cloud.outputs.public_subnets.*.id
}
