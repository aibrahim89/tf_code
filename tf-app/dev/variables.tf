variable "bucket_name" {
  description = "Name of the bucket"
  type        = string
  default = "modules-bucket"
}

variable "aws_region" {
    type = string
    default = "us-east-1"
}

variable "use_remote_state" {
  type    = bool
  default = true
}