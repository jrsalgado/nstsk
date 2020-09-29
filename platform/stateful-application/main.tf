provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}

module "ami" {
  source = "../../modules/ami"
  ami_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
}

module "wordpress" {
  source               = "../../modules/wordpress"
  ami                  = module.ami.ami_id
  app_env              = var.app_env
  vpc_id               = data.terraform_remote_state.cloud.outputs.vpc_main.id
  private_subnets      = data.terraform_remote_state.cloud.outputs.private_subnets.*.id
  public_subnets       = data.terraform_remote_state.cloud.outputs.public_subnets.*.id
  allow_ssh_cidr_block = "0.0.0.0/0"
}

output "subnets" {
  value = data.terraform_remote_state.cloud.outputs.public_subnets.*.id
}
