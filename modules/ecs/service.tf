resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-service"
  iam_role        = aws_iam_role.ecs_service_role.name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.wordpress.family}:${max("${aws_ecs_task_definition.wordpress.revision}", "${data.aws_ecs_task_definition.wordpress.revision}")}"
  desired_count   = 1
  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_target_group.arn
    container_port   = 80
    container_name   = "wordpress"
  }
}
