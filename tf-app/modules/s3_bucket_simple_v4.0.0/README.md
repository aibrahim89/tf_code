# Overview

Sets up a simple S3 Bucket with encryption.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Modules

No Modules.

## Resources

| Name |
|------|
| [aws_kms_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) |
| [aws_s3_bucket](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) |
| [aws_s3_bucket_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| block\_public\_access | (Optional) Manages S3 bucket-level Public Access Block configuration. | <pre>object({<br>    block_public_acls       = bool<br>    block_public_policy     = bool<br>    ignore_public_acls      = bool<br>    restrict_public_buckets = bool<br>  })</pre> | <pre>{<br>  "block_public_acls": true,<br>  "block_public_policy": true,<br>  "ignore_public_acls": true,<br>  "restrict_public_buckets": true<br>}</pre> | no |
| bucket\_name | Name of the bucket | `string` | `"my-bucket"` | no |
| is\_bucket\_kms\_encryption\_enabled | (Optional) - Set to true to enable KMS encryption. If set to false - AWS256 encryption will be applied | `bool` | `true` | no |
| is\_expiration\_enabled | (Optional) expiration of the deleted objects marker | <pre>object({<br>    expired_object_delete_marker  = bool<br>  })</pre> | <pre>{<br>  "expired_object_delete_marker": true<br>}</pre> | no |
| is\_force\_destroy\_enabled | (Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| is\_versioning\_enabled | Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `string` | `false` | no |
| lifecycle\_rule | (Optional) the name, and enabling the lifecycle rule and number of days for abort\_incomplete\_multipart\_upload. | <pre>object({<br>    id                                        = string<br>    enabled                                   = bool<br>    abort_incomplete_multipart_upload_days    = number<br>  })</pre> | <pre>{<br>  "abort_incomplete_multipart_upload_days": 2,<br>  "enabled": true,<br>  "id": "Retention-policy-3-months"<br>}</pre> | no |
| tags | (Optional) A mapping of tags to assign to the bucket. | `map(string)` | `{}` | no |
| transition | (Optional) List of the transitions inside the lifecycle rule. | <pre>list(object({<br>    days            = number<br>    storage_class   = string<br>  }))</pre> | <pre>[<br>  {<br>    "days": 30,<br>    "storage_class": "STANDARD_IA"<br>  },<br>  {<br>    "days": 90,<br>    "storage_class": "GLACIER"<br>  }<br>]</pre> | no |
| arn_iam_user_kms_access | (Optional) The ARN for IAM user to get access to the KMS encryption key | `string` | "" | no |
## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | n/a |
| bucket\_id | n/a |

## Setup

Add the following content in the file `main.tf` from the root folder:

__NOTE: `FIXME_VERSION` needs to be replaced with the current version of this module (or set it to `master`).__

```hcl
module "my_s3_bucket" {
    source                  = "github.com/goodyear/terraform-aws-s3//s3_bucket_simple?ref=FIXME_VERSION"
    bucket_name             = "my-bucket"
    tags                    = {
       Tag1    = "Value1"
       Tag2    = "Value2"
    }
}
```

(Optional) Control public ACL settings. You can omit this block and it will default to **block** all Public ACLs.
```hcl
module "my_s3_bucket" {
    source                  = "github.com/goodyear/terraform-aws-s3//s3_bucket_simple?ref=FIXME_VERSION"
    bucket_name             = "my-bucket"
    block_public_access = {
        block_public_acls       = false
        block_public_policy     = true
        ignore_public_acls      = false
        restrict_public_buckets = true
    }
    tags                    = {
       Tag1    = "Value1"
       Tag2    = "Value2"
    }
}
```

(Optional) change the default lifecycle. You can omit this block and it will be after `30` days to the `Standard-IA` and after `90` days to the `GLACIER` storage classes. You can delete or add more transition (like, `ONEZONE_IA`,  `DEEP_ARCHIVE`, or `INTELLIGENT_TIERING`) here in the module

### For updating or deleting one transition

```hcl
module "my_s3_bucket" {
    source                  = "github.com/goodyear/terraform-aws-s3//s3_bucket_simple?ref=FIXME_VERSION"
    bucket_name             = "my-bucket"
    transition          = [{
        days            = 50
        storage_class   = "STANDARD_IA"
    }]
    tags                    = {
       Tag1    = "Value1"
       Tag2    = "Value2"
    }
}
```
### For updating or adding more transition

```hcl
module "my_s3_bucket" {
    source                  = "github.com/goodyear/terraform-aws-s3//s3_bucket_simple?ref=FIXME_VERSION"
    bucket_name             = "my-bucket"
    
    transition          = [{
        days            = 30
        storage_class   = "STANDARD_IA"
    },
    {
        days            = 60
        storage_class   = "ONEZONE_IA"
    },
    {
        days            = 90
        storage_class   = "GLACIER"
    }]
    tags                    = {
       Tag1    = "Value1"
       Tag2    = "Value2"
    }
}
```


Add the following content in the file `outputs.tf` from the root folder:
```hcl
output "bucket_id" {
    value = module.s3.bucket_id
}

output "bucket_arn" {
    value = module.s3.bucket_arn
}

output "s3_bucket_policy_read_write_arn" {
  value = aws_iam_policy.s3_read_write.arn
}

output "s3_bucket_policy_read_only_arn" {
  value = aws_iam_policy.s3_read_only.arn
}
```

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | S3 bucket ARN |
| bucket\_id | S3 bucket name |
| bucket\_policy\_read\_only\_arn | S3 bucket policy read/write ARN |
| bucket\_policy\_read\_write\_arn| S3 bucket policy read/only ARN |

## Apply the TF Stack

```bash
terraform init
terraform plan
terraform apply


#... OUTPUT SUPPRESSED ...
```
