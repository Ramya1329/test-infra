# Purpose: Declare input variables required by this environment

variable "vpc_id" {
  description = "Existing VPC ID to reuse"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR block for subnetting"
  type        = string
}

variable "environment" {
  description = "Environment name (e.g., dev/test)"
  type        = string
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
}

variable "owner_tag" {
  description = "Owner tag to avoid naming conflict (e.g., team or user name)"
  type        = string
}
