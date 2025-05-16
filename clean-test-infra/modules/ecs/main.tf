#ECS CLUSTER CREATION

resource "aws_ecs_cluster" "main" {
  name = "ecs-cluster-${var.environment}"
}

#security grp for ecs 

resource "aws_security_group" "ecs_service" {
  name        = "ecs-service-sg-${var.environment}"
  description = "Allow ECS tasks internal comms"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-service-sg-${var.environment}"
  }
}

#Securitygroup for Database

resource "aws_security_group" "db" {
  name        = "db-sg-${var.environment}"
  description = "Allow backend apps to access DB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_service.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-sg-${var.environment}"
  }
}

#ECS LAUNCH TEMPLATE + ASG

data "aws_ami" "ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs" {
  name_prefix   = "ecs-lt-${var.environment}-"
  image_id      = data.aws_ami.ecs.id
  instance_type = "t3.medium"

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo "ECS_CLUSTER=${aws_ecs_cluster.main.name}" >> /etc/ecs/ecs.config
echo "ECS_BACKEND_HOST=ecs.amazonaws.com" >> /etc/ecs/ecs.config
systemctl enable --now ecs
EOF
)


  lifecycle {
    create_before_destroy = true
  }
}



#ASG Creation

resource "aws_autoscaling_group" "ecs" {
  desired_capacity    = 2
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.ecs.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSCluster"
    value               = aws_ecs_cluster.main.name
    propagate_at_launch = true
  }

  tag {
    key                 = "Name"
    value               = "ecs-asg-${var.environment}"
    propagate_at_launch = true
  }
}

#IAM ROLES


resource "aws_iam_role" "execution_role" {
  name = "${var.environment}-ecs-execution-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "secretsmanager" {
  role       = aws_iam_role.execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

#TASK ROLE FOR APP PERMISSIONS

resource "aws_iam_role" "task_role" {
  name = "${var.environment}-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

#instance role for ECS Agent

resource "aws_iam_role" "instance_role" {
  name = "${var.environment}-ecs-instance-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_instance_profile" "ecs" {
  name = "${var.environment}-ecs-instance-profile"
  role = aws_iam_role.instance_role.name
}

resource "aws_iam_role_policy_attachment" "ecs_instance_policy" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_cloudwatch_logs" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_container_service" {
  role       = aws_iam_role.instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}



