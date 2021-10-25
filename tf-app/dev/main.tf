provider "aws" {
  region  = "us-east-1"
}

/*module "my_vpc" {
    source       = "../modules/vpc"
    vpc_cider    = "192.168.0.0/16"
    tenancy      = "default" 
    vpc_id       = "${module.my_vpc.vpc_id}"
    subnet_cider = "192.168.1.0/24"

}

module "my_ec2" {
    source    = "../modules/ec2"
    ec2_count = 1
    ami_id    = "ami-09e67e426f25ce0d7"
    subnet_id = "${module.my_vpc.subnet_id}"
}*/


locals {
    destination_bucket_name = "goodyear-logging-s3-access-logs"
}


module "my_s3_bucket_log" {
    source                  = "../modules/terraform-aws-s3/s3_bucket_logging"
    bucket_name             = "modules-bucket-for-logging"
    important               = false
    destination_bucket_name = local.destination_bucket_name
    tags             = {
        Tag1    = "looging-bucket"
    }
    lifecycle_rule = {
        id                                        = "expire-all-objects-tomorrow"
        enabled                                   = true
        abort_incomplete_multipart_upload_days    = 1
    }
    is_expiration_enabled = {
        expired_object_delete_marker = true
    }
    transition = []
    replication_configuration = {
        rules = [
            {
                id       = "all-objects-replication-rule"
                status   = "Enabled"
                destination = {
                    bucket             = "arn:aws:s3:::${local.destination_bucket_name}" # Centralized logging Bucket full ARN
                    storage_class      = "STANDARD"
                    account_id         = "143480444354" # Centralized Logging Account ID
                }
            }
        ]
    }

}



module "my_s3_bucket" {
    source                  = "../modules/terraform-aws-s3/s3_bucket_simple"
    bucket_name             = "modules-bucket"
    arn_iam_user_kms_access = "arn:aws:sts::557804530956:assumed-role/Owner/abdallah_ibrahim@goodyear.com"
    is_force_destroy_enabled = true

}


/*data "aws_iam_policy_document" "bucket_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    effect = "Allow"
  }
}

resource "aws_iam_role" "bucket_role" {
  name               = "${var.bucket_name}-access-role"
  assume_role_policy = data.aws_iam_policy_document.bucket_role_policy_document.json
}

resource "aws_iam_policy_attachment" "s3readwrite" {
  name   = "${var.bucket_name}-s3-read-write-policy"
  roles   = ["${aws_iam_role.bucket_role.id}"]
  policy_arn = module.my_s3_bucket.bucket_policy_read_write_arn
  //var.use_remote_state  ? data.terraform_remote_state.this_stack[0].outputs.bucket_policy_read_write_arn : ""
}


resource "aws_iam_policy_attachment" "s3readonly" {
  name   = "${var.bucket_name}-s3-read-only-policy"
  roles   = ["${aws_iam_role.bucket_role.id}"]
  policy_arn = module.my_s3_bucket.bucket_policy_read_only_arn
  //var.use_remote_state  ? data.terraform_remote_state.this_stack[0].outputs.bucket_policy_read_only_arn : ""
}
*/
