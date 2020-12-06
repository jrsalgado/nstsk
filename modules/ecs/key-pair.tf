resource "aws_key_pair" "keypair" {
  key_name   = "${var.app_env}-keypair"
  public_key = file("${path.root}/files/id_rsa_evaluator.pub")
}
