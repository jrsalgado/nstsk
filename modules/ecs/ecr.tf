resource "aws_ecr_repository" "wordpress" {
  name                 = "wordpress"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}
