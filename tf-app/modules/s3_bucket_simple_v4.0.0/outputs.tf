output "bucket_id" {
  value = aws_s3_bucket._.id
}

output "bucket_arn" {
  value = aws_s3_bucket._.arn
}

output "bucket_policy_read_write_arn" {
  value = aws_iam_policy.s3_read_write.arn
}

output "bucket_policy_read_only_arn" {
  value = aws_iam_policy.s3_read_only.arn
}
