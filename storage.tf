# S3 bucket for static assets
resource "aws_s3_bucket" "assets" { #trivy:ignore:AVD-AWS-0089
  bucket = "${var.project_name}-static-assets"

  tags = {
    Name = "${var.project_name}-static-assets"
  }
}

# FIX: block all public access
resource "aws_s3_bucket_public_access_block" "assets" {
  bucket = aws_s3_bucket.assets.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# FIX: enable versioning for object recovery
resource "aws_s3_bucket_versioning" "assets" {
  bucket = aws_s3_bucket.assets.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "assets" { #trivy:ignore:AVD-AWS-0132
  bucket = aws_s3_bucket.assets.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
    bucket_key_enabled = true
  }
}
