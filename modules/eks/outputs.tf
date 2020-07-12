output "endpoint" {
  value = aws_eks_cluster.cluster_1.endpoint
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.cluster_1.certificate_authority.0.data
}
