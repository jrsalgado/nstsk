
resource "aws_vpc" "selected" {
   name = "${var.vpc_name}"
}

module "subnets" {
  source = "../subnets"
  names = [ "example1", "example2" ]
}
