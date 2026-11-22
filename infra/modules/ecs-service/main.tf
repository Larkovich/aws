data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  container_name = "status-api"
}
