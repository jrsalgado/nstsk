resource "aws_iam_role" "ecs_intance_role" {
  name               = "${var.app_env}-ecs-intance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.ecs_instance_policy.json
}

data "aws_iam_policy_document" "ecs_instance_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_intance_role-attachment" {
  role       = aws_iam_role.ecs_intance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.app_env}-ecs-instance-profile"
  path = "/"
  role = aws_iam_role.ecs_intance_role.id
  #    provisioner "local-exec" {
  #      command = "sleep 10"
  #    }
}
