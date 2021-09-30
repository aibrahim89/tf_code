resource "aws_kms_key" "_" {
  count                   = var.is_bucket_kms_encryption_enabled == true ? 1 : 0
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
  policy                  = data.aws_iam_policy_document.kms_key_policy.json
}
