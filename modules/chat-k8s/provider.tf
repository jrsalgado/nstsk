provider "kubernetes" {
    host                   = var.aws_eks_cluster.endpoint
    cluster_ca_certificate = var.aws_eks_cluster.certificate_authority.0.data
    load_config_file       = false
}
