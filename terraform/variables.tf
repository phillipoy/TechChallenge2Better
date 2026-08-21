# Declares input variables used across the Terraform configuration

variable "aws_region" {
  description = "AWS region to deploy infrastructure into"
  type        = string
}

variable "project_name" {
  description = "Name of the project, used for tagging resources"
  type        = string
}

variable "environment" {
  description = "Deployment environment (e.g. Development, Staging, Production)"
  type        = string

  # Restricts allowed values to catch typos before they hit AWS
  validation {
    condition     = contains(["Development", "Staging", "Production"], var.environment)
    error_message = "environment must be one of: Development, Staging, Production."
  }
}

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

# Defines the trusted CIDR block allowed to access the Jenkins server
variable "jenkins_admin_cidr" {
  description = "CIDR block allowed to access Jenkins over SSH and port 8080"
  type        = string
}