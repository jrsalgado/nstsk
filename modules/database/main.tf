resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.private_subnets

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_security_group" "rds" {
  name        = "rds-sg"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.sg_id_ingress]
  }

  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "RDS Instance"
  }
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 10
  identifier_prefix      = "mysql-${var.app_env}"
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = var.release_version
  instance_class         = var.instance_class
  name                   = var.name
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.default.name
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
}


