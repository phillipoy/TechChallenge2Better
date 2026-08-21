# Defines input variables used to configure the Jenkins EC2 instance

# Defines the AMI used to launch the Jenkins server
variable "ami_id" {
  description = "AMI ID used by the Jenkins EC2 instance"
  type        = string
}

# Defines the EC2 instance type used by the Jenkins server
variable "instance_type" {
  description = "EC2 instance type used by the Jenkins server"
  type        = string
  default     = "c7i-flex.large"
}

# Defines the subnet where the Jenkins server will be deployed
variable "subnet_id" {
  description = "ID of the subnet used by the Jenkins EC2 instance"
  type        = string
}

# Defines the SSH public key registered with the EC2 key pair
variable "public_key" {
  description = "SSH public key used to access the Jenkins EC2 instance"
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

# Defines the ECR repository ARN Jenkins is allowed to push images to
variable "ecr_repository_arn" {
  description = "ARN of the ECR repository used by the Jenkins pipeline"
  type        = string
}

# Defines security groups attached to the Jenkins EC2 instance
variable "security_group_ids" {
  description = "Security group IDs attached to the Jenkins EC2 instance"
  type        = list(string)
}