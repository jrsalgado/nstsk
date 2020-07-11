output "load_balancer_ip" {
  value = "${kubernetes_service.nginx_example.load_balancer_ingress.0.ip}"
}

output "load_balancer_hostname" {
  value = "${kubernetes_service.nginx_example.load_balancer_ingress.0.hostname}"
}
