terraform {
  backend "s3" {
    # From Makefile
    # terraform init  -backend-config="bucket=nstask" -backend-config="key=Task/develop"
    # key    = "nstask/Matillion"
    region         = "us-east-1"
    dynamodb_table = "terraform_states"
  }
}
