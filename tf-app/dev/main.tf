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


module "my_s3_bucket" {
    source                  = "../modules/s3"
    bucket_name             = "modules-bucket"

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
    }
    ]
}