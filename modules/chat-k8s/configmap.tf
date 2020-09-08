resource "kubernetes_config_map" "config_map_chat_app" {
  metadata {
    name      = "global-config"
    namespace = kubernetes_namespace.appchat.metadata.0.name
  }

  data = {
    "db.username"     = "node"
    "db.password"     = "node"
    "db.database"     = "nodedb"
    "db.port"         = "27017"
    "db.host"         = "mongo"
    "app.redis_host"  = "redis"
    "app.rabbit_host" = "rabbit"
    "app.nats_host"   = "nats"
    "app.port"        = "3000"
    "app.scalable"    = "true"
  }
}
