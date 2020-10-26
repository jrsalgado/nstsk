provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
  profile = var.aws_profile
}

locals {
  prefix = replace(var.app_env, "/[[:punct:]]/", "-")
}

module "eks_cluster" {
  source = "../../modules/eks"
  prefix = local.prefix
  private_subnets = data.terraform_remote_state.cloud.outputs.private_subnets.*.id
}
