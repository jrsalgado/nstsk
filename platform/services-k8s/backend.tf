terraform {
  backend "s3" {
    # From Makefile
    # terraform init  -backend-config="bucket=nstask" -backend-config="key=Task/develop"
    # key    = "nstask/Matillion"
    region = "us-east-1"
  }
}

data "terraform_remote_state" "k8s" {
  backend = "s3"
  config = {
    bucket  = "terraform-states.nearsoft"
    profile = var.aws_profile
    region  = "us-east-1"
    key     = "Task/${var.app_env}/k8s"
  }
}