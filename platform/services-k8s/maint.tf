provider "kubernetes" {
  config_context_auth_info = "ops"
  config_context_cluster   = "mycluster"
}

# Chat
# Frontend
# Backend
# Redis
# Mysql
module "chat" {
  source = "../../modules/chat-k8s"
  
}
# App2
# Data processing
# module "app2" {
#   source = ""
# }
