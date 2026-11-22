include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "../../../modules//ecr"
}

# Prod sets deletion_protection = true, so terragrunt refuses to destroy it by accident
prevent_destroy = local.env.deletion_protection

inputs = {
  force_delete = !local.env.deletion_protection
}
