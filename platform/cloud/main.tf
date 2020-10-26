provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  prefix = replace(var.app_env, "/[[:punct:]]/", "-")
}

module "network" {
  source = "../../modules/network"

  prefix               = local.prefix
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
