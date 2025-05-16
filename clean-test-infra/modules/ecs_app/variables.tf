variable "app_name" {
  description = "Name of the application"
  type        = string
}

variable "environment" {
  description = "Environment (e.g., dev, staging, prod)"
  type        = string
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "execution_role_arn" {
  type = string
}

variable "task_role_arn" {
  type = string
}

variable "image_url" {
  type = string
}

variable "port" {
  type = number
}

variable "subnets" {
  type = list(string)
}

variable "ecs_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "db_secret_arn" {
  type    = string
  default = null
}

variable "api_url" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "db_host" {
  type = string
  default = null
}
