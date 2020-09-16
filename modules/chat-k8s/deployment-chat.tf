resource "kubernetes_service" "docker_chat_app" {
  metadata {
    name      = "${var.prefix}-docker-chat-app"
    namespace = kubernetes_namespace.appchat.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.docker_chat_app.spec.0.template.0.metadata[0].labels.App
    }
    port {
      name:       = "http"
      port        = 8080
      target_port = 3000
    }

    type = "NodePort"
  }

  depends_on = [
    kubernetes_deployment.docker_chat_app
  ]
}

resource "kubernetes_deployment" "docker_chat_app" {
  metadata {
    name      = "${var.prefix}-docker-chat-app"
    namespace = kubernetes_namespace.appchat.metadata.0.name
    labels = {
      App = "docker-chat-app"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "docker-chat-app"
      }
    }
    template {
      metadata {
        labels = {
          App = "docker-chat-app"
        }
      }
      spec {
        container {
          image   = "ageapps/docker-chat:app"
          name    = "docker-chat-app"
          command = ["/bin/sh", "-c", "nodemon ./bin/www"]

          env {
            name = "PORT"
            value_from {
              config_map_key_ref {
                key  = "app.port"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }
          
          env {
            name = "MONGO_PASSWORD"
            value_from {
              config_map_key_ref {
                key  = "db.password"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }

          env {
            name = "MONGO_USERNAME"
            value_from {
              config_map_key_ref {
                key  = "db.username"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }
          
          env {
            name = "MONGO_DATABASE"
            value_from {
              config_map_key_ref {
                key  = "db.database"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }
          
          env {
            name = "DB_PORT"
            value_from {
              config_map_key_ref {
                key  = "db.port"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }

          env {
            name = "DB_HOST"
            value_from {
              config_map_key_ref {
                key  = "db.host"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }
            
          env {
            name = "SCALABLE"
            value_from {
              config_map_key_ref {
                key  = "app.scalable"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }

          port {
            container_port = 3000
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }

  depends_on = [
    kubernetes_service.mongo
  ]
}
