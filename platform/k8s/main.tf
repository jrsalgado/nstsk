
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}
locals {
  sufix = replace(var.app_env, "/[[:punct:]]/", "-")
}
resource "aws_eks_cluster" "cluster_1" {
  name     = "${local.sufix}-1"
  role_arn = aws_iam_role.eks_role.arn

  vpc_config {
    # subnet_ids = ["${aws_subnet.example1.id}", "${aws_subnet.example2.id}"]
    subnet_ids = data.terraform_remote_state.cloud.outputs.private_subnets.*.id
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]
}


resource "aws_eks_node_group" "eks_nodes" {
  cluster_name    = aws_eks_cluster.cluster_1.name
  node_group_name = "${local.sufix}-eks-nodes"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = data.terraform_remote_state.cloud.outputs.private_subnets.*.id

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
  ]
}