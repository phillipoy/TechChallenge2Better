# Defines input variables used to configure the VPC module

# Defines the CIDR block allocated to the VPC
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

# Defines CIDR blocks allocated to public subnets
variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

# Defines CIDR blocks allocated to private subnets
variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
}

# Defines the project name used for resource naming and identification
variable "project_name" {
  description = "Name of the project"
  type        = string
}

# Defines the deployment environment
variable "environment" {
  description = "Deployment environment"
  type        = string
}