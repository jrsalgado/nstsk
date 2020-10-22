resource "aws_ecs_cluster" "ecs-cluster" {
    name = "ecs_cluster_${var.app_env}"
}
