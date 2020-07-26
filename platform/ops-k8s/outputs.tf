output "k8s_dashboard_proxy_endpoint" {
  value       = "http://127.0.0.1:8001/api/v1/namespaces/${local.kubernetes_dashboard_ns}/services/https:${local.kubernetes_dashboard_ns}:https/proxy/#!/login"
  description = "kubectl proxy endpoint"
}
output "k8s_dashboard_access_token" {
  value       = "kubectl -n ${local.kubernetes_dashboard_ns} describe secret $(kubectl -n ${local.kubernetes_dashboard_ns} get secret | grep admin-user | awk '{print $1}')"
  description = "get access token command"
}
