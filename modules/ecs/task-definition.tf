data "aws_ecs_task_definition" "wordpress" {
  task_definition = aws_ecs_task_definition.wordpress.family
  depends_on      = [aws_ecs_task_definition.wordpress]
}

resource "aws_ecs_task_definition" "wordpress" {
  family = "wordpress"
  container_definitions = templatefile("${path.module}/files/task-definition.json",
    { mysql_endpoint    = var.mysql_endpoint,
      mysql_db_username = var.mysql_db_username,
      mysql_db_password = var.mysql_db_password,
      mysql_db_name     = var.mysql_db_name,
  ecr_image_url = aws_ecr_repository.wordpress.repository_url })
}

