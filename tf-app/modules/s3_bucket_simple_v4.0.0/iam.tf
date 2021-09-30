data "aws_caller_identity" "current" {}

resource "aws_iam_policy" "s3_read_write" {
  name   = "${var.bucket_name}-Read-Write-s3-policy"
  policy = data.aws_iam_policy_document.s3_policy_read_write.json
}

resource "aws_iam_policy" "s3_read_only" {
  name   = "${var.bucket_name}-Read-only-s3-policy"
  policy = data.aws_iam_policy_document.s3_policy_read_only.json
}

data "aws_iam_policy_document" "s3_policy_read_write" {

  statement {
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutBucketWebsite",
      "s3:AbortMultipartUpload",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:MoveObject",
      "s3:PutBucketVersioning",
      "s3:GetObject",
      "s3:List*"
    ]
    resources = [
      //"arn:aws:s3:::${var.bucket_name}",
      //"arn:aws:s3:::${var.bucket_name}/*"
      aws_s3_bucket._.arn,
      "${aws_s3_bucket._.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key._[0].arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:ListKeys",
      "kms:ListAliases"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "s3_policy_read_only" {

  statement {
    effect = "Allow"
    actions = [
      "s3:GetBucketLogging",
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:List*"
    ]
    resources = [
      //"arn:aws:s3:::${var.bucket_name}",
      //"arn:aws:s3:::${var.bucket_name}/*"
      aws_s3_bucket._.arn,
      "${aws_s3_bucket._.arn}/*"
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = [aws_kms_key._[0].arn]
  }

  statement {
    effect = "Allow"
    actions = [
      "kms:ListKeys",
      "kms:ListAliases"
    ]
    resources = ["*"]
  }
}



data "aws_iam_policy_document" "kms_key_policy" {
  statement {
    effect = "Allow"
    sid    = "Enable IAM User Permissions"
    actions = ["kms:*"]
    resources = ["*"]
    principals {
      type = "AWS"
      identifiers = var.arn_iam_user_kms_access == "" ? [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]: [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
        var.arn_iam_user_kms_access
      ]
    }
  }
}