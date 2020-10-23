resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${var.app_env}"
}
