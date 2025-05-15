output "service_name" {
  value = aws_ecs_service.app.name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.ecs_app.name
}

output "task_definition_arn" {
  value = aws_ecs_task_definition.app.arn
} 