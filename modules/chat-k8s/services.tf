resource "kubernetes_service" "nginx_example" {
  metadata {
    name      = "${var.prefix}-nginx-example"
    namespace = kubernetes_namespace.appchat.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx_example.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 80
    }

    type = "LoadBalancer"
  }
}
