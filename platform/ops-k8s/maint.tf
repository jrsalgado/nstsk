provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}

data "aws_eks_cluster_auth" "auth" {
  name = data.terraform_remote_state.k8s.outputs.eks_cluster.name
}

provider "kubernetes" {
  token                  = data.aws_eks_cluster_auth.auth.token
  host                   = data.terraform_remote_state.k8s.outputs.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.k8s.outputs.eks_cluster.certificate_authority.0.data)
  load_config_file       = false
}

provider "helm" {
  kubernetes {
    token                  = data.aws_eks_cluster_auth.auth.token
    host                   = data.terraform_remote_state.k8s.outputs.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.terraform_remote_state.k8s.outputs.eks_cluster.certificate_authority.0.data)
    load_config_file       = false
  }
}

locals {
  prefix = replace(var.app_env, "/[[:punct:]]/", "-")
  kubernetes_dashboard_ns = "kubernetes-dashboard"
}

module "dashboard_k8s" {
  source = "../../modules/dashboard-k8s"
  namespace = local.kubernetes_dashboard_ns
  prefix = local.prefix
  oidc_provider = data.terraform_remote_state.k8s.outputs.eks_cluster.identity[0].oidc[0].issuer
}

module "prometheus_k8s" {
  source = "../../modules/prometheus-k8s"
  namespace = "kube-system"
  prefix = local.prefix
}

module "alb_ingress_k8s" {
  source = "../../modules/alb-ingress-k8s"
  namespace = "kube-system"
  prefix = local.prefix
  cluster_name = data.terraform_remote_state.k8s.outputs.eks_cluster.name
  cluster_arn = data.terraform_remote_state.k8s.outputs.eks_cluster.arn
  cluster_url = data.terraform_remote_state.k8s.outputs.eks_cluster.endpoint
}
