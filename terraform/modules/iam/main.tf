data "aws_caller_identity" "current" {}

resource "aws_iam_role" "lite-role" {
  name = "${lower(var.environment)}-${lower(var.app)}-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          AWS = "data.aws_caller_identity.current.account_id"
        }
      },
    ]
  })

  tags = var.tags
}

resource "aws_iam_group_policy" "lite-policy" {
  name  = "${lower(var.environment)}-${lower(var.app)}-policy"
  group = aws_iam_group.lite-group.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
        ]
        Effect   = "Allow"
        Resource = "${aws_iam_role.lite-role.arn}"
      },
    ]
  })
}

resource "aws_iam_group" "lite-group" {
  name = "${lower(var.environment)}-${lower(var.app)}-group"
  path = "/${lower(var.environment)}-${lower(var.app)}-group/"
}

resource "aws_iam_user" "lite-user" {
  name = "${lower(var.environment)}-${lower(var.app)}-user"
  tags = var.tags
}

resource "aws_iam_user_group_membership" "lite-membership" {
  user = aws_iam_user.lite-user.name

  groups = [
    aws_iam_group.lite-group.name,
  ]
}