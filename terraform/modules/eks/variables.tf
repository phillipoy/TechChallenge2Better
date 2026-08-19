# Defines input variables used to configure the EKS cluster

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

# Defines the private subnets used by the EKS control plane
variable "private_subnet_ids" {
  description = "IDs of the private subnets used by the EKS cluster"
  type        = list(string)
}
