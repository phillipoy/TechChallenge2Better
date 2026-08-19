# Exposes the ECR repository URL for Docker image pushes and Kubernetes deployments
output "repository_url" {
  description = "URL of the ECR repository"
  value       = aws_ecr_repository.application.repository_url
}

# Exposes the ECR repository ARN for use by supporting AWS resources
output "repository_arn" {
  description = "ARN of the ECR repository"
  value       = aws_ecr_repository.application.arn
}

# Exposes the ECR repository name for use by deployment workflows
output "repository_name" {
  description = "Name of the ECR repository"
  value       = aws_ecr_repository.application.name
}