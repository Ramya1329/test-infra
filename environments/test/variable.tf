# Purpose: Declare input variables required by this environment

variable "environment" {
  description = "Environment name (e.g., dev/test)"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}