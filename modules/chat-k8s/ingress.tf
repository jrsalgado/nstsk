resource "kubernetes_ingress" "chat_app_ingress" {
  metadata {
    name      = "${var.prefix}-ingress"
    namespace = kubernetes_namespace.appchat.metadata.0.name

    annotations = {
      "kubernetes.io/ingress.class"               = "nginx"
      "ingress.kubernetes.io/affinity"            = "cookie"
      "ingress.kubernetes.io/session-cookie-name" = "route"
      "ingress.kubernetes.io/session-cookie-hash" = "sha1"
      "ingress.kubernetes.io/rewrite-target"      = "/"
    }
  }

  spec {
    backend {
      service_name = kubernetes_service.docker_chat_app.metadata.0.name
      service_port = 8080
    }

    rule {
      http {
        path {
          backend {
            service_name = kubernetes_service.docker_chat_app.metadata.0.name
            service_port = 8080
          }

          path = "/"
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.docker_chat_app
  ]
}
