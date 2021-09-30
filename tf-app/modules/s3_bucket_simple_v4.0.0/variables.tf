variable "block_public_access" {
  default = {
    block_public_acls       = true
    block_public_policy     = true
    ignore_public_acls      = true
    restrict_public_buckets = true
  }
  description = "(Optional) Manages S3 bucket-level Public Access Block configuration."
  type        = object({
    block_public_acls       = bool
    block_public_policy     = bool
    ignore_public_acls      = bool
    restrict_public_buckets = bool
  })
}

variable "bucket_name" {
  default     = "my-bucket"
  description = "Name of the bucket"
  type        = string
}

variable "is_bucket_kms_encryption_enabled" {
  default     = true
  description = "(Optional) - Set to true to enable KMS encryption. If set to false - AWS256 encryption will be applied"
  type        = bool
}

variable "is_expiration_enabled" {
  default = {
    expired_object_delete_marker  = true
  }
  description = "(Optional) expiration of the deleted objects marker"
  type        = object({
    expired_object_delete_marker  = bool
  })
}

variable "is_force_destroy_enabled" {
  default     = false
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
}

variable "is_versioning_enabled" {
  default     = false
  description = "Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  type        = string
}

variable "lifecycle_rule" {
  default = {
    id                                        = "Retention-policy-3-months"
    enabled                                   = true
    abort_incomplete_multipart_upload_days    = 2
  }
  description = "(Optional) the name, and enabling the lifecycle rule and number of days for abort_incomplete_multipart_upload."
  type        = object({
    id                                        = string
    enabled                                   = bool
    abort_incomplete_multipart_upload_days    = number
  })
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
}

variable "transition" {
  default = [{
    days            = 30
    storage_class   = "STANDARD_IA"
  },
  {
    days            = 90
    storage_class   = "GLACIER"
  }]
  description = "(Optional) List of the transitions inside the lifecycle rule."
  type        = list(object({
    days            = number
    storage_class   = string
  }))
}

variable "arn_iam_user_kms_access" {
  default     = ""
  description = "ARN for IAM user to access the kms key"
  type        = string
}

