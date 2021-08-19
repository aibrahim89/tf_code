provider "aws" {
  region  = "us-east-1"
}

module "my_vpc" {
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
}


/* module "my_s3_bucket" {
    source                  = "../modules/s3"
    bucket_name             = "modules-bucket"

    # transition_2            = {
    #     days            = 100
    #     storage_class   = "GLACIER"
    # }
    lifecycle_rule = [{
      id                                     = "log"
      enabled                                = true
      
      abort_incomplete_multipart_upload_days = 2  
        
      expiration_inputs = [{
        expired_object_delete_marker = true
        },
      ]
      expiration_inputs = []
      transition_inputs = []

      transition_inputs = [{
        days                         = 90
        storage_class                = "GLACIER"
        },
      ]
    },
    ]   
} */

module "aws_s3_bucket" {
  source      = "../modules/s3"
  bucket_name = "s3-tf-example-lifecycle"

  lifecycle_rule = [{
    id                                     = "log"
    enabled                                = true
    prefix                                 = "log/"
    abort_incomplete_multipart_upload_days = 2
    tags = {
      "rule"      = "log"
      "autoclean" = "true"
    }

    expiration_inputs = [{
      days                         = 90
      date                         = "19/08/2021"
      expired_object_delete_marker = true
      },
    ]
    transition_inputs                    = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        }
    ]
    noncurrent_version_transition_inputs = []
    noncurrent_version_expiration_inputs = []

    },
    {
      id                                     = "log1"
      enabled                                = true
      prefix                                 = "log1/"
      abort_incomplete_multipart_upload_days = null
      tags = {
        "rule"      = "log1"
        "autoclean" = "true"
      }

      expiration_inputs = []
      transition_inputs = []
      noncurrent_version_transition_inputs = [
        {
          days          = 30
          storage_class = "STANDARD_IA"
        },
        {
          days          = 60
          storage_class = "ONEZONE_IA"
        },
        {
          days          = 90
          storage_class = "GLACIER"
        },
      ]
      noncurrent_version_expiration_inputs = []
    },
  ]
}