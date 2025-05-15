resource "aws_db_subnet_group" "main" {
  name       = "rds-subnet-group-${var.environment}"
  subnet_ids = var.private_subnets

  tags = {
    Name = "rds-subnet-group-${var.environment}"
  }
}

data "aws_secretsmanager_secret_version" "db" {
  secret_id = var.db_secret_arn
}

resource "aws_db_instance" "main" {
  allocated_storage    = 20
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t3.medium"
  db_name              = "sampledb"
  username             = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["DB_USER"]
  password             = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)["DB_PASS"]
  vpc_security_group_ids = [var.db_sg_id]
  db_subnet_group_name = aws_db_subnet_group.main.name
  skip_final_snapshot  = true
  publicly_accessible  = false
  multi_az             = false

  tags = {
    Name = "rds-${var.environment}"
  }
}
