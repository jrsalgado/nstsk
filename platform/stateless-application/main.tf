provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}

module "ami" {
  source    = "../../modules/ami"
  ami_name  = "amzn2-ami-ecs-hvm-2.0.20201013-x86_64-ebs"
  ami_owner = "591542846629" # amazon
}

module "database" {
  source          = "../../modules/database"
  private_subnets = data.terraform_remote_state.cloud.outputs.private_subnets.*.id
  app_env         = var.app_env
  vpc_id          = data.terraform_remote_state.cloud.outputs.vpc_main.id
  sg_id_ingress   = module.ecs.ecs_instances_sg_id
}

module "ecs" {
  source            = "../../modules/ecs"
  vpc_id            = data.terraform_remote_state.cloud.outputs.vpc_main.id
  private_subnets   = data.terraform_remote_state.cloud.outputs.private_subnets.*.id
  public_subnets    = data.terraform_remote_state.cloud.outputs.public_subnets.*.id
  ami_id            = module.ami.ami_id
  app_env           = var.app_env
  mysql_endpoint    = module.database.database_endpoint
  mysql_db_name     = "wordpress"
  mysql_db_username = "wordpress"
  mysql_db_password = "wordpress"
}

