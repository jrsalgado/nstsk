provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
  profile = var.aws_profile
}

module "wordpress" {
  source = "../../modules/wordpress"
}
