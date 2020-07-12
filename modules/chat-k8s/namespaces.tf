resource "kubernetes_namespace" "appchat" {
  metadata {
    annotations = {
      name = "appchat"
    }
    name = "appchat"
  }
}
