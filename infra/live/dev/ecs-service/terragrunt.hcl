include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../../modules//ecs-service"
}

# Prod sets deletion_protection = true, so terragrunt refuses to destroy it by accident
prevent_destroy = local.env.deletion_protection

dependency "network" {
  config_path = "../network"

  mock_outputs = {
    vpc_id          = "vpc-0123456789abcdef0"
    public_subnets  = ["subnet-0123456789abcdef0", "subnet-0123456789abcdef1"]
    private_subnets = ["subnet-0123456789abcdef2", "subnet-0123456789abcdef3"]
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "ecr" {
  config_path = "../ecr"

  mock_outputs = {
    repository_url = "111111111111.dkr.ecr.eu-central-1.amazonaws.com/mock"
    repository_arn = "arn:aws:ecr:eu-central-1:111111111111:repository/mock"
  }
  mock_outputs_allowed_terraform_commands = ["validate", "plan", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

inputs = {
  vpc_id             = dependency.network.outputs.vpc_id
  public_subnet_ids  = dependency.network.outputs.public_subnets
  private_subnet_ids = dependency.network.outputs.private_subnets
  ecr_repository_url = dependency.ecr.outputs.repository_url
  ecr_repository_arn = dependency.ecr.outputs.repository_arn

  greeting            = local.env.greeting
  cpu                 = local.env.cpu
  memory              = local.env.memory
  desired_count       = local.env.desired_count
  log_retention_days  = local.env.log_retention_days
  container_insights  = local.env.container_insights
  deletion_protection = local.env.deletion_protection
}
