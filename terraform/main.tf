provider "aws" {
  region = "eu-west-1"  # Change to your desired AWS region
}

data "aws_ecr_repository" "lambda_repository" {
  name = "ai-ask-me-a-joke"
}

resource "aws_lambda_function" "ai-ask-me-a-joke-lambda" {
  function_name = "ai-ask-me-a-joke-lambda"
  package_type  = "Image"
  image_uri     = "${aws_ecr_repository.lambda_repository.repository_url}:latest"

  environment {
    variables = {
      ANTHROPIC_API_KEY = env.ANTHROPIC_API_KEY
    }
  }

  # IAM role for Lambda execution (optional if you're attaching this in a different way)
  role = aws_iam_role.lambda_exec_role.arn
}

resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = ""
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_log_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_exec_role.name
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"
  description = "IAM policy for Lambda function to write logs"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "logs:CreateLogGroup"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "logs:CreateLogStream"
        Resource = "*"
        Effect   = "Allow"
      },
      {
        Action   = "logs:PutLogEvents"
        Resource = "*"
        Effect   = "Allow"
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_log_policy" {
  policy_arn = aws_iam_policy.lambda_policy.arn
  role       = aws_iam_role.lambda_exec_role.name
}