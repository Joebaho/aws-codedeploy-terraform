# S3 Bucket
resource "aws_s3_bucket" "codedeploy_bucket" {
  bucket = "${var.project_name}-bucket-backup01"
}

resource "aws_s3_bucket_ownership_controls" "codedeploy_bucket" {
  bucket = aws_s3_bucket.codedeploy_bucket.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "codedeploy_bucket" {
  depends_on = [aws_s3_bucket_ownership_controls.codedeploy_bucket]
  bucket     = aws_s3_bucket.codedeploy_bucket.id
  acl        = "private"
}
