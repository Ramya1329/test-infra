locals {
  container_env = [
    {
      name  = "NEXT_PUBLIC_API_URL"
      value = var.api_url
    }
  ]

  container_secrets = var.db_secret_arn != null ? [
    {
      name      = "DB_USER"
      valueFrom = var.db_secret_arn
    },
    {
      name      = "DB_PASS"
      valueFrom = var.db_secret_arn
    },
    {
      name      = "MYSQL_ROOT_PASSWORD"
      valueFrom = var.db_secret_arn
    }
  ] : []
}
# ecs/logging.tf

resource "aws_cloudwatch_log_group" "ecs_app" {
  name              = "/ecs/${var.app_name}-${var.environment}"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "app" {
  family                   = "${var.app_name}-${var.environment}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = var.execution_role_arn
  task_role_arn            = var.task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.app_name,
      image     = var.image_url,
      essential = true,
      portMappings = [
        {
          containerPort = var.port,
          hostPort      = var.port
        }
      ],
      environment = local.container_env,
      secrets     = local.container_secrets
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = "/ecs/${var.app_name}-${var.environment}",
          awslogs-region        = var.region,
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

depends_on = [aws_cloudwatch_log_group.ecs_app]
}

resource "aws_ecs_service" "app" {
  name            = "${var.app_name}-svc"
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.app.arn
  desired_count   = 1
  launch_type     = "EC2"

  network_configuration {
    subnets         = var.subnets
    security_groups = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.app_name
    container_port   = var.port
  }

  depends_on = [aws_ecs_task_definition.app]
}