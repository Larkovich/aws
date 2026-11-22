variable "name" {
  description = "Name of the cluster, service, ALB and related resources"
  type        = string
}

variable "vpc_id" {
  description = "VPC to run in"
  type        = string
}

variable "public_subnet_ids" {
  description = "Subnets for the load balancer"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Subnets for the ECS tasks"
  type        = list(string)
}

variable "ecr_repository_url" {
  description = "ECR repository with the app image"
  type        = string
}

variable "ecr_repository_arn" {
  description = "ARN of the ECR repository, used in the execution role policy"
  type        = string
}

variable "image_tag" {
  description = "Image tag for the first deployment. Later deployments are done by CI/CD"
  type        = string
  default     = "bootstrap"
}

variable "container_port" {
  description = "Port the app listens on"
  type        = number
  default     = 8080
}

variable "greeting" {
  description = "Value of the GREETING env variable returned by GET /"
  type        = string
}

variable "cpu" {
  description = "Task CPU units (256 = 0.25 vCPU)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Task memory in MiB"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Number of running tasks"
  type        = number
  default     = 1
}

variable "log_retention_days" {
  description = "How long CloudWatch keeps the app logs"
  type        = number
  default     = 14
}

variable "container_insights" {
  description = "Enable CloudWatch Container Insights on the cluster"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Protect the load balancer from deletion"
  type        = bool
  default     = false
}

variable "alarm_5xx_threshold" {
  description = "Number of 5xx responses per minute that triggers the alarm"
  type        = number
  default     = 10
}
