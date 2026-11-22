output "plan_role_arn" {
  description = "Read-only role for pull request pipelines"
  value       = aws_iam_role.github["plan"].arn
}

output "infra_role_arn" {
  description = "Role for terragrunt apply after merge"
  value       = aws_iam_role.github["infra"].arn
}

output "deploy_role_arn" {
  description = "Role for pushing the image and deploying the app"
  value       = aws_iam_role.github["deploy"].arn
}
