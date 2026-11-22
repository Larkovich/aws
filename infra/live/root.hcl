# Always Terraform (same as CI), even when OpenTofu is installed on the machine
terraform_binary             = "terraform"
terraform_version_constraint = ">= 1.10"

locals {
  env     = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  project = "status-api"
  name    = "${local.project}-${local.env.environment}"
}

# One state bucket per AWS account, one state file per unit, e.g. dev/ecs-service/terraform.tfstate.
# use_lockfile = S3 native locking, no DynamoDB table needed.
remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket       = "${local.project}-tfstate-${local.env.account_id}"
    key          = "${path_relative_to_include()}/terraform.tfstate"
    region       = local.env.region
    encrypt      = true
    use_lockfile = true
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<-EOF
    provider "aws" {
      region              = "${local.env.region}"
      allowed_account_ids = ["${local.env.account_id}"]

      default_tags {
        tags = {
          Project     = "${local.project}"
          Environment = "${local.env.environment}"
          ManagedBy   = "terragrunt"
        }
      }
    }
  EOF
}

inputs = {
  name = local.name
}
