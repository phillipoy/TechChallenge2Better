# Defines environment-specific values used by the Terraform configuration

aws_region   = "us-east-1"
project_name = "eks-project"
environment  = "Development"

vpc_cidr = "10.0.0.0/16"

public_subnet_cidrs = [
  "10.0.1.0/24",
  "10.0.2.0/24"
]

private_subnet_cidrs = [
  "10.0.10.0/24",
  "10.0.20.0/24"
]

# Defines the trusted public IP allowed to access Jenkins
jenkins_admin_cidr = "192.74.129.47/32"