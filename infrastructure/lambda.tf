resource "aws_iam_role" "graphql" {
  name               = "graphql"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["lambda.amazonaws.com", "edgelambda.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

## Manually Add CloudWatch Log Group for Lambda
resource "aws_cloudwatch_log_group" "lambda" {
  name              = "/aws/lambda/${var.app_name}"
  retention_in_days = 7
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "${var.app_name}-lambda-logging"
  path        = "/service-role/"
  description = "IAM Policy for ${var.app_name}-lambda-logging"
  policy      = data.aws_iam_policy_document.lambda_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_to_lambda_role" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.graphql.name
}

resource "aws_lambda_function" "graphql" {
  function_name    = var.app_name
  filename         = "${path.module}/assets/lambda_payload.zip"
  role             = aws_iam_role.graphql.arn
  handler          = "index.handler"
  publish          = true
  runtime          = "nodejs12.x"
  source_code_hash = filebase64sha256("${path.module}/assets/lambda_payload.zip")

  tags = {
    Name = "${var.app_name}-graphql"
    Project = var.app_name
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  version   = "2012-10-17"
  policy_id = "PolicyForGraphQLLambdaLogging"
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
  }
}
