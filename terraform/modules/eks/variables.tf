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

# Defines the Jenkins IAM role granted deployment access to the EKS cluster
variable "jenkins_role_arn" {
  description = "ARN of the Jenkins IAM role requiring access to the EKS cluster"
  type        = string
}

# Defines the Jenkins security group allowed to access the EKS API server
variable "jenkins_security_group_id" {
  description = "ID of the security group used by the Jenkins EC2 instance"
  type        = string
}