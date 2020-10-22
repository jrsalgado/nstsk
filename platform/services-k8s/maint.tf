provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
  profile = var.aws_profile
}

data "aws_eks_cluster_auth" "auth" {
  name = data.terraform_remote_state.k8s.outputs.eks_cluster.name
}

provider "kubernetes" {
  token                  = data.aws_eks_cluster_auth.auth.token
  host                   = data.terraform_remote_state.k8s.outputs.eks_cluster.endpoint
  cluster_ca_certificate = "${base64decode(data.terraform_remote_state.k8s.outputs.eks_cluster.certificate_authority.0.data)}"
  load_config_file       = false
}

locals {
  prefix = replace(var.app_env, "/[[:punct:]]/", "-")
}

module "chat" {
  source = "../../modules/chat-k8s"
  prefix = local.prefix
}

