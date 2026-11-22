variable "name" {
  description = "Name prefix, for example status-api-dev"
  type        = string
}

variable "github_subject_prefix" {
  description = "Start of the OIDC sub claim. Immutable format repo:owner@owner_id/name@repo_id, so a renamed or re-created repo with the same name can not assume the roles"
  type        = string

  validation {
    condition     = startswith(var.github_subject_prefix, "repo:")
    error_message = "Must start with repo:, see: gh api repos/OWNER/REPO/actions/oidc/customization/sub"
  }
}

variable "github_environment" {
  description = "GitHub environment of the app deploy job. Infra apply uses <environment>-infra"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ECR repository the deploy role can push to"
  type        = string
}

variable "ecs_cluster_name" {
  description = "ECS cluster of the service the deploy role can update"
  type        = string
}

variable "ecs_service_name" {
  description = "ECS service the deploy role can update"
  type        = string
}

variable "ecs_execution_role_name" {
  description = "Task execution role the deploy role can pass to ECS"
  type        = string
}
