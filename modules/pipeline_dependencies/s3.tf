resource "aws_s3_bucket" "input" {
  count  = var.create_input_bucket ? 1 : 0
  bucket = "${var.env}-sn-pipenline-input"
  force_destroy = true
}

resource "aws_s3_bucket" "output" {
  count  = var.create_output_bucket ? 1 : 0
  bucket = "${var.env}-sn-pipenline-output"
  force_destroy = true
}