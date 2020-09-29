terraform {
  backend "s3" {
    # From Makefile
    # terraform init  -backend-config="bucket=nstask" -backend-config="key=Task/develop"
    # key    = "nstask/Matillion"
    region = "us-east-1"
    dynamodb_table = "terraform_states"
  }
}

data "terraform_remote_state" "cloud" {
  backend = "s3"
  config = {
#    bucket  = "terraform-states.nearsoft"
    bucket  = "alfredo-terraform-states.nearsoft"
    profile = var.aws_profile
    region  = "us-east-1"
    key     = "Task/${var.app_env}/cloud"
    dynamodb_table = "terraform_states"
  }
}
