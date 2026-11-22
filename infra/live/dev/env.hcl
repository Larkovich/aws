# Enviroment specific settings. Every unit in this folder reads this file.
locals {
  environment = "dev"
  account_id  = "065306945239"
  region      = "eu-central-1"

  # Network
  vpc_cidr           = "10.10.0.0/16"
  azs                = ["eu-central-1a", "eu-central-1b"]
  single_nat_gateway = true
  enable_flow_logs   = false

  # Service
  greeting            = "Hello from dev!"
  cpu                 = 256
  memory              = 512
  desired_count       = 1
  log_retention_days  = 14
  container_insights  = false
  deletion_protection = false
}
