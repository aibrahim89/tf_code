provider "aws" {
  region  = "us-east-2"
}

resource "aws_s3_bucket" "test-rp" {
  bucket = "tf-test-r-policy"
  acl    = "private"

  lifecycle_rule {
    id      = "rp_3months"
    enabled = true

    abort_incomplete_multipart_upload_days = 2

    transition {
      days          = 30
      storage_class = "STANDARD_IA" 
    }

    transition {
      days          = 90
      storage_class = "GLACIER"
    }

    expiration {
      expired_object_delete_marker = true
    }
  }
}