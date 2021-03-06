resource "aws_kms_key" "_" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "_" {
  bucket        = var.bucket_name
  acl           = "private"
  tags          = var.tags
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = var.lifecycle_rule.id
    enabled = var.lifecycle_rule.enabled
    abort_incomplete_multipart_upload_days = var.lifecycle_rule.abort_incomplete_multipart_upload_days

    dynamic "transition" {
        for_each = try(jsondecode(var.transition), var.transition)

        content {
          days          = lookup(transition.value, "days", null)
          storage_class = transition.value.storage_class
        }
      }

    expiration {
      expired_object_delete_marker = var.expiration.expired_object_delete_marker
    }
  }

  server_side_encryption_configuration {
    rule {
        apply_server_side_encryption_by_default {
          kms_master_key_id = aws_kms_key._.id
          sse_algorithm     = "aws:kms"
        }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "_" {
  bucket = var.bucket_name

  block_public_acls       = var.block_public_access.block_public_acls
  block_public_policy     = var.block_public_access.block_public_policy
  ignore_public_acls      = var.block_public_access.ignore_public_acls
  restrict_public_buckets = var.block_public_access.restrict_public_buckets
}
