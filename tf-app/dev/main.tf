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
    source                  = "../modules/s3_bucket_simple"
    bucket_name             = "modules-bucket"
    trusted_service         = "lambda"
    arn_iam_user_kms_access = "arn:aws:sts::557804530956:assumed-role/Owner/abdallah_ibrahim@goodyear.com"

    principals          = [{
        type            = "Service"
        identifiers     = "lambda.amazonaws.com"
    }]
}