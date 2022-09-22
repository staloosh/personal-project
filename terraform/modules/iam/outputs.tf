output "role" {
  value = aws_iam_role.lite-role.name
}

output "policy" {
  value = aws_iam_group_policy.lite-policy.name
}

output "group" {
  value = aws_iam_group.lite-group.name
}

output "user" {
  value = aws_iam_user.lite-user.name
}