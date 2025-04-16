resource "aws_s3_bucket" "devops_bucket" {
  bucket = "${var.project}-devops-state"
  force_destroy = true
}