resource "aws_s3_bucket" "_" {
  bucket        = var.bucket_name
  acl           = "private"
  tags          = var.tags
  force_destroy = var.is_force_destroy_enabled

  versioning {
    enabled = var.is_versioning_enabled
  }

  lifecycle_rule {
    id                                     = var.lifecycle_rule.id
    enabled                                = var.lifecycle_rule.enabled
    abort_incomplete_multipart_upload_days = var.lifecycle_rule.abort_incomplete_multipart_upload_days

    dynamic "transition" {
      for_each = try(jsondecode(var.transition), var.transition)

      content {
        days          = lookup(transition.value, "days", null)
        storage_class = transition.value.storage_class
      }
    }

    expiration {
      expired_object_delete_marker = var.is_expiration_enabled.expired_object_delete_marker
    }
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = var.is_bucket_kms_encryption_enabled == true ? aws_kms_key._[0].id : ""
        sse_algorithm     = var.is_bucket_kms_encryption_enabled == true ? "aws:kms" : "AES256"
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
