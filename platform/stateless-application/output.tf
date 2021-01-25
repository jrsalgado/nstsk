output "ecs_alb_public_dns" {
  value = "http://${module.ecs.ecs_alb_public_dns}"
}
