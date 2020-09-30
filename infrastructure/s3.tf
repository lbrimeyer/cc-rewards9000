data "aws_iam_policy_document" "bucket_policy" {
  version   = "2012-10-17"
  policy_id = "PolicyForCloudFrontPrivateContent"
  statement {
    actions   = ["s3:GetObject"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.domain_name}/*"]

    principals {
      type        = "AWS"
      identifiers = [var.origin_access_identity_iam_arn]
    }
  }
  statement {
    actions   = ["s3:ListBucket"]
    effect    = "Allow"
    resources = ["arn:aws:s3:::${var.domain_name}"]

    principals {
      type        = "AWS"
      identifiers = [var.origin_access_identity_iam_arn]
    }
  }
}

## Create s3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = var.domain_name
  acl    = var.s3_acl
  policy = data.aws_iam_policy_document.bucket_policy.json

  lifecycle_rule {
    id      = "Transition to cheaper storage"
    enabled = var.s3_transition_flag

    transition {
      days          = var.s3_transition_days
      storage_class = var.s3_storage_class
    }
  }

  tags = {
    Name = var.domain_name
    Project = var.app_name
  }
}
