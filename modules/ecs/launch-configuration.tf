resource "aws_launch_configuration" "ecs-launch-configuration" {
    name_prefix                 = "ecs-launch-configuration"
    image_id                    = var.ami_id
    instance_type               = var.instance_type
    iam_instance_profile        = aws_iam_instance_profile.ecs-instance-profile.id

    root_block_device {
      volume_type = "standard"
      volume_size = 100
      delete_on_termination = true
    }

    lifecycle {
      create_before_destroy = true
    }

    security_groups             = [ aws_security_group.sg.id ]
    associate_public_ip_address = "true"
    key_name                    = aws_key_pair.keypair.key_name
    user_data                   = templatefile("${path.module}/files/user-data.sh", { ecs_cluster = aws_ecs_cluster.ecs-cluster.name })
}
