output "cluster_attr" {
  value = aws_eks_cluster.cluster_1
}
output "aws_iam_openid_connect_provider_attr" {
  value = aws_iam_openid_connect_provider.cluster
}
