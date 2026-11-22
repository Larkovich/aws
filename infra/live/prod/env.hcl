# Enviroment specific settings. Every unit in this folder reads this file.
# Prod is meant to live in a separate AWS account (own state bucket and OIDC provider).
locals {
  environment = "prod"
  account_id  = "222222222222"
  region      = "eu-central-1"

  # Network
  vpc_cidr           = "10.20.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b", "eu-central-1c"]
  single_nat_gateway = false
  enable_flow_logs   = true

  # Service
  greeting            = "Hello from prod!"
  cpu                 = 512
  memory              = 1024
  desired_count       = 2
  log_retention_days  = 90
  container_insights  = true
  deletion_protection = true
}
