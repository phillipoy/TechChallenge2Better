# Defines input variables used to configure the EKS managed node group

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

# Defines the name of the EKS cluster the worker nodes will join
variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

# Defines the private subnets where EKS worker nodes will be deployed
variable "private_subnet_ids" {
  description = "IDs of the private subnets used by the EKS worker nodes"
  type        = list(string)
}

# Defines the EC2 instance type used by EKS worker nodes
variable "instance_type" {
  description = "EC2 instance type used by the EKS managed node group"
  type        = string
  default     = "t3.small"
}

# Defines the minimum number of worker nodes available in the node group
variable "min_size" {
  description = "Minimum number of EKS worker nodes"
  type        = number
  default     = 1
}

# Defines the desired number of worker nodes when the node group is created
variable "desired_size" {
  description = "Desired number of EKS worker nodes"
  type        = number
  default     = 1
}

# Defines the maximum number of worker nodes allowed in the node group
variable "max_size" {
  description = "Maximum number of EKS worker nodes"
  type        = number
  default     = 4
}