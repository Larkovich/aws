include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../../modules//github-oidc"
}

# Bootstrap unit, applied once by an admin from a laptop.
# CI never applies it, so the pipeline can not change its own permissions.
exclude {
  if      = get_env("GITHUB_ACTIONS", "false") == "true"
  actions = ["apply", "destroy"]
}

dependency "ecr" {
  config_path = "../ecr"

  mock_outputs = {
    repository_arn = "arn:aws:ecr:eu-central-1:111111111111:repository/mock"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan"]
}

inputs = {
  github_subject_prefix   = "repo:Larkovich@71225579/aws@1467819181"
  github_environment      = local.env.environment
  ecr_repository_arn      = dependency.ecr.outputs.repository_arn
  ecs_cluster_name        = include.root.locals.name
  ecs_service_name        = include.root.locals.name
  ecs_execution_role_name = "${include.root.locals.name}-ecs-execution"
}
