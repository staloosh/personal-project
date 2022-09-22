output "aws_iam_role_name" {
  value = module.iam.role
}

output "aws_iam_group_policy_name" {
  value = module.iam.policy
}

output "aws_iam_group_name" {
  value = module.iam.group
}

output "aws_iam_user_name" {
  value = module.iam.user
}