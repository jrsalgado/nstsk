output "ecs_instances_sg_id" {
  value = aws_security_group.ecs_instances_sg.id
}

output "ecs_alb_public_dns" {
  value = aws_alb.ecs_load_balancer.dns_name
}
