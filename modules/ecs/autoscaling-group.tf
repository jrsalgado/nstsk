resource "aws_autoscaling_group" "ecs-autoscaling-group" {
    name                        = "ecs-autoscaling-group"
    max_size                    = var.asg_max_instance_size
    min_size                    = var.asg_min_instance_size
    desired_capacity            = var.asg_desired_capacity
    vpc_zone_identifier         = var.public_subnets
    launch_configuration        = aws_launch_configuration.ecs-launch-configuration.name
    health_check_type           = "ELB"
    tag {
      key                 = "Name"
      value               = "ecs-cluster-instance-${var.app_env}"
      propagate_at_launch = true
    }
}