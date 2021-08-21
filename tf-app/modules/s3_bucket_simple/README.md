# Overview

Sets up a simple S3 Bucket with encryption.

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| block\_public\_access | (Optional) Manages S3 bucket-level Public Access Block configuration. | <pre>object({<br>    block_public_acls       = bool<br>    block_public_policy     = bool<br>    ignore_public_acls      = bool<br>    restrict_public_buckets = bool<br>  })</pre> | <pre>{<br>  "block_public_acls": true,<br>  "block_public_policy": true,<br>  "ignore_public_acls": true,<br>  "restrict_public_buckets": true<br>}</pre> | no |
| bucket\_name | Name of the bucket | `string` | `"my-bucket"` | no |
| force\_destroy | (Optional, Default:false ) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable. | `bool` | `false` | no |
| tags | (Optional) A mapping of tags to assign to the bucket. | `map(string)` | `{}` | no |
| versioning | Once you version-enable a bucket, it can never return to an unversioned state. You can, however, suspend versioning on that bucket. | `string` | `false` | no |
|lifecycle_rule|(optional) creating a lifecycle rule  for the bucket block {name, enable, and number of days for abort_incomplete_multipart_upload}|block: <br> `string` <br> `bool` <br> `number`|`"Retention-policy-3-months"` <br> `true` <br> `2`|no|
|transition|(optional) List of object for the lifecycle transitions|`list(object[number, string])`|`{days = 30 <br> storage_class   = "STANDARD_IA"} <br> {days = 90 <br> storage_class   = "GLACIER"}`|no|
|expiration|(mandatory, Default:true, Block) A boolean that indicates the deletion of the expired object delet marker|`bool`|`expired_object_delete_marker  = true`|no|

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

### For updating or delecting one transition

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
```

## Outputs

| Name | Description |
|------|-------------|
| bucket\_arn | S3 bucket ARN |
| bucket\_id | S3 bucket name |


## Apply the TF Stack

```bash
terraform init
terraform plan
terraform apply


#... OUTPUT SUPPRESSED ...
```
