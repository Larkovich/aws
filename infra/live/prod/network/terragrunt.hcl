include "root" {
  path   = find_in_parent_folders("root.hcl")
  expose = true
}

locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws?version=6.8.0"
}

# Prod sets deletion_protection = true, so terragrunt refuses to destroy it by accident
prevent_destroy = local.env.deletion_protection

inputs = {
  cidr = local.env.vpc_cidr
  azs  = local.env.azs

  # /24 per AZ: public 10.x.0.0, 10.x.1.0 ... private 10.x.10.0, 10.x.11.0 ...
  public_subnets  = [for i in range(length(local.env.azs)) : cidrsubnet(local.env.vpc_cidr, 8, i)]
  private_subnets = [for i in range(length(local.env.azs)) : cidrsubnet(local.env.vpc_cidr, 8, i + 10)]

  # Tasks run in private subnets and reach ECR and CloudWatch through NAT.
  # Dev has a single NAT to save money, prod has one NAT per AZ.
  enable_nat_gateway     = true
  single_nat_gateway     = local.env.single_nat_gateway
  one_nat_gateway_per_az = !local.env.single_nat_gateway

  enable_flow_log                                 = local.env.enable_flow_logs
  create_flow_log_cloudwatch_log_group            = local.env.enable_flow_logs
  create_flow_log_cloudwatch_iam_role             = local.env.enable_flow_logs
  flow_log_cloudwatch_log_group_retention_in_days = local.env.log_retention_days
  vpc_flow_log_iam_role_name                      = "${include.root.locals.name}-vpc-flow-logs"
  vpc_flow_log_iam_role_use_name_prefix           = false
  vpc_flow_log_iam_policy_name                    = "${include.root.locals.name}-vpc-flow-logs"
  vpc_flow_log_iam_policy_use_name_prefix         = false
}
