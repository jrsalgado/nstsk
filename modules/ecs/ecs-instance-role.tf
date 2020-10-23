resource "aws_iam_role" "ecs-intance-role" {
    name                = "ecs-intance-role"
    path                = "/"
    assume_role_policy  = data.aws_iam_policy_document.ecs-instance-policy.json
}

data "aws_iam_policy_document" "ecs-instance-policy" {
    statement {
        actions = ["sts:AssumeRole"]

        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
            #identifiers = ["ecs-tasks.amazonaws.com"]
        }
    }
}

resource "aws_iam_role_policy_attachment" "ecs-intance-role-attachment" {
    role       = aws_iam_role.ecs-intance-role.name
    #policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs-instance-profile" {
    name = "ecs-instance-profile"
    path = "/"
    role = aws_iam_role.ecs-intance-role.id
#    provisioner "local-exec" {
#      command = "sleep 10"
#    }
}
