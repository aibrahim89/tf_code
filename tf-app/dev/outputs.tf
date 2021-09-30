output "bucket_id" {
  value = module.my_s3_bucket.bucket_id
}

output "bucket_arn" {
  value = module.my_s3_bucket.bucket_arn
}

output "bucket_policy_read_write_arn" {
  value =module.my_s3_bucket.bucket_policy_read_write_arn
}

output "bucket_policy_read_only_arn" {
  value = module.my_s3_bucket.bucket_policy_read_only_arn
}