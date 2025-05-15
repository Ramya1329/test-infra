output "ecs_sg_id" {
  value = aws_security_group.ecs_service.id
}


output "cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "execution_role_arn" {
  value = aws_iam_role.execution_role.arn
}

output "db_sg_id" {
  value = aws_security_group.db.id
}

output "task_role_arn" {
  value = aws_iam_role.task_role.arn
}

