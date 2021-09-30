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




module "my_s3_bucket" {
    source                  = "../modules/s3_bucket_simple_v4.0.0"
    bucket_name             = "modules-bucket"
    //trusted_service         = "lambda"
    arn_iam_user_kms_access = "arn:aws:sts::557804530956:assumed-role/Owner/abdallah_ibrahim@goodyear.com"

    /*principals          = [{
        type            = "Service"
        identifiers     = "lambda.amazonaws.com"
    }]*/
}


data "aws_iam_policy_document" "bucket_role_policy_document" {
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

