provider "aws" {
  region = "us-east-1"  # Choose your AWS region
}

# S3 Bucket for DevOps state
resource "aws_s3_bucket" "devops_bucket" {
  bucket        = "${var.project}-devops-state"
  force_destroy = true  # Allow the bucket to be deleted even if it contains objects
}

output "s3_bucket_name" {
  value = aws_s3_bucket.devops_bucket.bucket
}
