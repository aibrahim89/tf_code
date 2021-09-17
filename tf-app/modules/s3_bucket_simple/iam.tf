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

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "bucket_role_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    dynamic "principals" {
      for_each = try(jsondecode(var.principals), var.principals)

      content {
        identifiers = [principals.value.identifiers]
        type        = principals.value.type
      }
    }
    effect = "Allow"
  }
}


/*resource "aws_iam_role" "bucket_role" {
  name               = "${var.bucket_name}-access-role"
  assume_role_policy = data.aws_iam_policy_document.bucket_role_policy_document.json
}*/

/*resource "aws_iam_role_policy" "s3" {
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
      aws_s3_bucket._.arn,
      "${aws_s3_bucket._.arn}/*"
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
    resources = ["${aws_kms_key._.arn}"]
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

*/

resource "aws_iam_policy" "s3_read_write" {
  name   = "${var.bucket_name}-Read-Write-s3-policy"
  //role   = aws_iam_role.bucket_role.id
  policy = data.aws_iam_policy_document.s3_policy_read_write.json
}

resource "aws_iam_policy" "s3_read_only" {
  name   = "${var.bucket_name}-Read-only-s3-policy"
  //role   = aws_iam_role.bucket_role.id
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
    resources = ["${aws_kms_key._.arn}"]
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
    resources = ["${aws_kms_key._.arn}"]
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

/*data "aws_iam_policy_document" "bucket_policy" {
  statement {
    effect = "Allow"
    actions = [
      "s3:List*"
    ]
    resources = [
      "arn:aws:s3:::${var.bucket_name}",
      "arn:aws:s3:::${var.bucket_name}/*"
      //aws_s3_bucket._.arn,
      //"${aws_s3_bucket._.arn}/*"
    ]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}*/