resource "aws_iam_openid_connect_provider" "auth0" {
  url = var.openid_connect_provider_url
  client_id_list = var.openid_connect_provider_client_ids
  thumbprint_list = var.openid_connect_provider_thumbprints
}

/*
Reference on how to get the thumbprint:
https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_providers_create_oidc_verify-thumbprint.html
*/

resource "aws_cognito_identity_pool" "auth0" {
  identity_pool_name               = var.cognito_pool_name
  allow_unauthenticated_identities = false
  openid_connect_provider_arns = [aws_iam_openid_connect_provider.auth0.arn]
}

## Authenticated Role
resource "aws_iam_role" "cognito_authenticated" {
  name = "Cognito${var.cognito_pool_name}AuthenticatedRole"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.cognito_authenticated_assume_role.json
}

data "aws_iam_policy_document" "cognito_authenticated_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values = [
       aws_cognito_identity_pool.auth0.id,
      ]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values = [
        "authenticated",
      ]
    }
  }
}

## Unauthenticated Role
resource "aws_iam_role" "cognito_unauthenticated_role" {
  name = "Cognito${var.cognito_pool_name}UnauthorizedRole"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.cognito_unauthenticated_assume_role.json
}

resource "aws_iam_policy" "cognito_unauthenticated_role" {
  name = "Cognito${var.cognito_pool_name}Unauthenticated_Role"
  policy = data.aws_iam_policy_document.cognito_unauthenticated_role.json
  path = "/"
  description = "Role policy for Cognito ${var.cognito_pool_name} Unauthorized users"
}

data "aws_iam_policy_document" "cognito_unauthenticated_role" {
  statement {
    effect  = "Allow"
    actions = [
      "mobileanalytics:PutEvents",
      "cognito-sync:*"
    ]
    resources = ["*"]
  }
}

data "aws_iam_policy_document" "cognito_unauthenticated_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = ["cognito-identity.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "cognito-identity.amazonaws.com:aud"
      values = [
       aws_cognito_identity_pool.auth0.id,
      ]
    }

    condition {
      test     = "ForAnyValue:StringLike"
      variable = "cognito-identity.amazonaws.com:amr"
      values = [
        "unauthenticated",
      ]
    }
  }
}

resource "aws_cognito_identity_pool_roles_attachment" "cognito_unauth_attatch_role" {
  identity_pool_id = aws_cognito_identity_pool.auth0.id

  roles = {
    "authenticated" = aws_iam_role.cognito_authenticated.arn
    "unauthenticated" = aws_iam_role.cognito_unauthenticated_role.arn
  }
}
