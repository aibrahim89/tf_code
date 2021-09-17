output "bucket_id" {
  value = aws_s3_bucket._.id
}

output "bucket_arn" {
  value = aws_s3_bucket._.arn
}

output "s3_bucket_policy_read_write_arn" {
  value = aws_iam_policy.s3_read_write.arn
}

output "s3_bucket_policy_read_only_arn" {
  value = aws_iam_policy.s3_read_only.arn
}

/*data "aws_caller_identity" "current" {}

locals {
    account_id = data.aws_caller_identity.current.account_id
}

output "account_id" {
  value = data.local.account_id
}
output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}*/