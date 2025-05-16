variable "environment" {
  description = "Deployment environment name"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR block"
  type        = string
}

variable "azs" {
  description = "List of availability zones"
  type        = list(string)
}

# Use a variable to pass existing VPC ID

variable "vpc_id" {
  description = "VPC ID to use (existing VPC)"
  type        = string
}

variable "owner_tag" {
  description = "Extra tag to avoid naming conflicts (e.g., your name/team)"
  type        = string
}
