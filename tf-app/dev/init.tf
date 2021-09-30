/*terraform {
  //required_version = "= 0.13.4"
  backend "s3" {
    bucket = "dataplatform-prod-statefiles"
    key = "modules_bucket.tfstate"
    region = "us-east-1"
//    profile = "saml"
  }
}*/


/*data "terraform_remote_state" "this_stack" {
  count = var.use_remote_state ? 1 : 0
  backend = "s3"

  config = {
    region = var.aws_region
    bucket = "dataplatform-prod-statefiles"
    key    = "stack_modules_bucket.tfstate"
  }
}*/