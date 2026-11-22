output "url" {
  description = "Public URL of the service"
  value       = "http://${aws_lb.this.dns_name}"
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.this.name
}

output "service_name" {
  description = "ECS service name"
  value       = aws_ecs_service.this.name
}

output "task_definition_family" {
  description = "Task definition family used by CI/CD to register new revisions"
  value       = aws_ecs_task_definition.this.family
}

output "container_name" {
  description = "Container name inside the task definition"
  value       = local.container_name
}

output "log_group_name" {
  description = "CloudWatch log group with app logs"
  value       = aws_cloudwatch_log_group.app.name
}
