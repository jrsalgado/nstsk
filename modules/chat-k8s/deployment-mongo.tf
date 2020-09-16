resource "kubernetes_service" "mongo" {
  metadata {
    name      = "${var.prefix}-mongo"
    namespace = kubernetes_namespace.appchat.metadata.0.name
  }
  spec {
    selector = {
      App = kubernetes_deployment.mongo.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 27017
      target_port = 27017
    }

    type = "NodePort"
  }

  depends_on = [
    kubernetes_deployment.mongo
  ]
}

resource "kubernetes_deployment" "mongo" {
  metadata {
    name      = "${var.prefix}-mongo"
    namespace = kubernetes_namespace.appchat.metadata.0.name
    labels = {
      App = "mongo"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "mongo"
      }
    }
    template {
      metadata {
        labels = {
          App = "mongo"
        }
      }
      spec {
        container {
          image = "ageapps/docker-chat:mongo"
          name  = "mongo"


          env {
            name = "MONGO_DB_APP_PASSWORD"
            value_from {
              config_map_key_ref {
                key  = "db.password"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }
            
          env {
            name = "MONGO_DB_APP_USERNAME"
            value_from {
              config_map_key_ref {
                key  = "db.username"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }
            
          env {
            name = "MONGO_DB_APP_DATABASE"
            value_from {
              config_map_key_ref {
                key  = "db.database"
                name = kubernetes_config_map.config_map_chat_app.metadata.0.name
              }
            }
          }

          port {
            container_port = 27017
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
}
