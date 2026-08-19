# Defines input variables used to configure security groups

# Defines the VPC where security groups will be created
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
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