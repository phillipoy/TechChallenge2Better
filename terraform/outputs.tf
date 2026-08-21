# Exposes the VPC ID created by the networking module
output "vpc_id" {
  description = "ID of the provisioned VPC"
  value       = module.vpc.vpc_id
}

# Exposes the public subnet IDs created by the networking module
output "public_subnet_ids" {
  description = "IDs of the provisioned public subnets"
  value       = module.vpc.public_subnet_ids
}

# Exposes the private subnet IDs created by the networking module
output "private_subnet_ids" {
  description = "IDs of the provisioned private subnets"
  value       = module.vpc.private_subnet_ids
}

# Exposes the Cluster Autoscaler IAM role ARN for Helm configuration
output "cluster_autoscaler_role_arn" {
  description = "ARN of the IAM role used by the Cluster Autoscaler"
  value       = module.eks.cluster_autoscaler_role_arn
}

# Exposes the AWS Load Balancer Controller IAM role ARN for Helm configuration
output "alb_controller_role_arn" {
  description = "ARN of the IAM role used by the AWS Load Balancer Controller"
  value       = module.eks.alb_controller_role_arn
}

# Exposes the EKS cluster name for Kubernetes and Helm configuration
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.cluster_name
}

# Exposes the ECR repository URL for application image deployment
output "ecr_repository_url" {
  description = "URL of the ECR repository used to store application images"
  value       = module.ecr.repository_url
}

## Exposes the public IP address of the Jenkins EC2 instance
output "jenkins_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = module.ec2.jenkins_public_ip
}