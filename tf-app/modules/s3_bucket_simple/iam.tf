/*data "aws_iam_policy_document" "kms_s3" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
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
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}*/

data "aws_iam_policy_document" "bucket_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    dynamic "principals" {
      for_each = try(jsondecode(var.principals), var.principals)

      content {
        identifiers = principals.value.identifiers
        type        = principals.value.type
      }
    }
    effect = "Allow"
  }
}


resource "aws_iam_role" "bucket_role" {
  name               = "${var.bucket_name}-access-role"
  assume_role_policy = data.aws_iam_policy_document.bucket_role_policy_document.json
}

resource "aws_iam_role_policy" "s3" {
  name   = "${var.bucket_name}-s3-policy"
  role   = aws_iam_role.bucket_role.id
  policy = data.aws_iam_policy_document.s3_access.json
}


resource "aws_iam_role_policy" "kms" {
  name   = "${var.bucket_name}-kms-policy"
  role   = aws_iam_role.bucket_role.id
  policy = data.aws_iam_policy_document.kms.json
}



data "aws_iam_policy_document" "s3_access" {
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
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
    ]
  }
}


data "aws_iam_policy_document" "kms" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}


