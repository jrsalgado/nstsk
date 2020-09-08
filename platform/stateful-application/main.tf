provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}


module "ami" {
  source = "../../modules/ami"
}

module "wordpress" {
  source          = "../../modules/wordpress"
  ami             = module.ami_ubuntu_18_04
  app_env         = var.app_env
  private_subnets = data.terraform_remote_state.cloud.outputs.private_subnets.*.id

}
