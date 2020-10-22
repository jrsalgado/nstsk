resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = var.private_subnets

  tags = {
    Name = "DB subnet group"
  }
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 10
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = var.release_version
  instance_class       = var.instance_class
  name                 = var.name
  username             = var.username
  password             = var.password
  db_subnet_group_name = aws_db_subnet_group.default.name 
  skip_final_snapshot  = true
}

