variable "prefix" {
  description = "Prefix to name resources"
}

variable "cluster_name" {}
variable "cluster_arn" {}
variable "cluster_url" {}

variable "namespace" {
  description = "K8s dashboard namespace"
}
