provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}

module "network" {
  source = "../../modules/network"

  prefix               = var.app_env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

module "eks" {
  source = "../../modules/eks"

  prefix               = var.app_env
  subnets              = module.network.public_subnets
}

module "chat-k8s" {
  source = "../../modules/chat-k8s"

  prefix          = var.app_env
  aws_eks_cluster = module.eks.aws_eks_cluster
}
