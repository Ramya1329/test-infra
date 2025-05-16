# The ID of the existing VPC, used by other modules like ECS, RDS, ALB

output "vpc_id" {
  value = var.vpc_id
}

# List of public subnet IDs, used to launch internet-facing resources like ALB or public ECS services

output "public_subnets" {
  value = aws_subnet.public[*].id
}

# List of private subnet IDs, used for internal services like backend ECS or RDS databases

output "private_subnets" {
  value = aws_subnet.private[*].id
}

# CIDR block assigned to the VPC, useful for setting up security group rules

output "vpc_cidr_block" {
  value = aws_vpc.main.cidr_block
}

# Availability zones used for subnet distribution (for visibility or referencing)

output "azs_used" {
  value = aws_subnet.public[*].availability_zone
}

# The first public subnet ID, commonly used for NAT gateway or testing

output "public_subnet_1" {
  value = aws_subnet.public[0].id
}

# The first private subnet ID, useful for placing database or ECS backend

output "private_subnet_1" {
  value = aws_subnet.private[0].id
}

# NAT gateway ID, used by private subnets to access the internet

output "nat_gateway_id" {
  value = aws_nat_gateway.main.id
}
