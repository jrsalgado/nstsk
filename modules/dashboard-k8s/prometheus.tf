
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "prometheus"
  namespace  = kubernetes_namespace.k8s_dashboard.metadata.0.name
  values = [
    file("${path.module}/files/prometheus_values.yaml")
  ]
}
data "aws_caller_identity" "current" {}
