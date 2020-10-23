##----------------------------------------------------
#resource "aws_iam_role" "ecsTaskExecutionRole" {
#  name               = "execution-role-ecs"
#  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
#}
#
#data "aws_iam_policy_document" "assume_role_policy" {
#  statement {
#    actions = ["sts:AssumeRole"]
#
#    principals {
#      type        = "Service"
#      identifiers = ["ecs-tasks.amazonaws.com"]
#    }
#  }
#}
#
##----------------------------------------------------

#AmazonEC2ContainerServiceRole

data "aws_ecs_task_definition" "wordpress" {
  task_definition = aws_ecs_task_definition.wordpress.family
  depends_on = [ aws_ecs_task_definition.wordpress ]
}

resource "aws_ecs_task_definition" "wordpress" {
    family                = "wordpress"
    container_definitions = templatefile("${path.module}/files/task-definition.json",
                                         { mysql_endpoint    = var.mysql_endpoint, 
                                           mysql_db_username = var.mysql_db_username, 
                                           mysql_db_password = var.mysql_db_password,
                                           mysql_db_name     = var.mysql_db_name, 
                                           ecr_image_url     = aws_ecr_repository.wordpress.repository_url })
#    execution_role_arn   = aws_iam_role.ecs-execution-role.arn
}

