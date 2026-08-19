# Exposes the VPC ID for use by other Terraform modules
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

# Exposes the public subnet IDs for internet-facing resources such as load balancers
output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

# Exposes the private subnet IDs for EKS worker nodes and internal resources
output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

# Exposes the Internet Gateway ID for resources that require public internet routing
output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

# Exposes the NAT Gateway ID used by private subnets for outbound internet access
output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.main.id
}