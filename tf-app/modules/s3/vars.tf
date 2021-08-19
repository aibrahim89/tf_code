variable "bucket_name" {
  default     = "my-bucket"
  description = "Name of the bucket"
  type        = string
}

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

variable "versioning" {
  default     = false
  description = "Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket."
  type        = string
}

variable "tags" {
  default     = {}
  description = "(Optional) A mapping of tags to assign to the bucket."
  type        = map(string)
}

variable "force_destroy" {
  default     = false
  description = "(Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  type        = bool
}

variable "lifecycle_rule_name" {
  default     = "RP-3-months"
  description = "Name of the retention policy"
  type        = string
}


variable "lifecycle_rule_enable" {
  default     = true
  description = "(mandatory, Default:true) A boolean that indicates that the lifecycle is enabled or not"
  type        = bool
}

variable "lifecycle_rule_abort_incomplete_multipart_upload_days" {
  default     = 2
  description = "Number of days to abort the incomplete multi-part uploads"
  type        = number
}

variable "lifecycle_rule_transition1_days" {
  default     = 30
  description = "Number of days for appplying the first transition"
  type        = number
}

variable "lifecycle_rule_storage_class1" {
  default     = "STANDARD_IA"
  description = "The storage class for the first transition, where the files will go!"
  type        = string
}

variable "lifecycle_rule_transition2_days" {
  default     = 90
  description = "Number of days for appplying the second transition"
  type        = number
}

variable "lifecycle_rule_storage_class2" {
  default     = "GLACIER"
  description = "The storage class for the second transition, where the files will go!"
  type        = string
}

variable "lifecycle_rule_expired_object_delete_marker" {
  default     = true
  description = "(mandatory, Default:true) A boolean that indicates the deletion of the expired object delet marker"
  type        = bool
}

variable "lifecycle_rule" {
  default = {
    id                                        = "RP-3-months"
    enabled                                   = true
    abort_incomplete_multipart_upload_days    = 2
  }
  description = "(Optional) Manages S3 bucket-level Public Access Block configuration."
  type        = object({
    id                                        = string
    enabled                                   = bool
    abort_incomplete_multipart_upload_days    = number
  })
}

variable "transition_1" {
  default = {
    days            = 30
    storage_class   = "STANDARD_IA"
  }
  description = "(Optional) Manages S3 bucket-level Public Access Block configuration."
  type        = object({
    days            = number
    storage_class   = string
  })
}

variable "transition_2" {
  default = {
    days            = 90
    storage_class   = "GLACIER"
  }
  description = "(Optional) Manages S3 bucket-level Public Access Block configuration."
  type        = object({
    days            = number
    storage_class   = string
  })
}

variable "expiration" {
  default = {
    expired_object_delete_marker  = true
  }
  description = "(Optional) Manages S3 bucket-level Public Access Block configuration."
  type        = object({
    expired_object_delete_marker  = bool
  })
}