
resource "helm_release" "prometheus" {
  name       = "prometheus"
  repository = "https://kubernetes-charts.storage.googleapis.com"
  chart      = "prometheus"
  namespace  = var.namespace
  values = [
    file("${path.module}/files/prometheus_values.yaml")
  ]
}
