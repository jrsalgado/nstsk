terraform {
  backend "s3" {
    # From Makefile
    # terraform init  -backend-config="bucket=nstask" -backend-config="key=Task/develop"
    # key    = "nstask/Matillion"
    profile = var.aws_profile
    region = "us-east-1"
  }
}
