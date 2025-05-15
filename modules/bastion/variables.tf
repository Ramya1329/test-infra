variable "environment" {}
variable "vpc_id" {}
variable "public_subnet_id" {}
variable "key_name" {
  description = "EC2 Key Pair name for SSH access"
}
variable "allowed_ip_cidr" {
  description = "Your public IP with /32 (e.g., 203.0.113.25/32)"
}
