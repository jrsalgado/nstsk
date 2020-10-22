resource "aws_key_pair" "keypair" {
  key_name   = "keypair-${var.app_env}"
  public_key = file("${path.root}/files/id_rsa_evaluator.pub")
}
