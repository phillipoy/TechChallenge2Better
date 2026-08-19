# Exposes the EKS cluster name for use by supporting modules and deployment workflows
output "cluster_name" {
  description = "Name of the EKS cluster"
  value       = aws_eks_cluster.main.name
}

# Exposes the EKS cluster ARN for use by supporting AWS resources
output "cluster_arn" {
  description = "ARN of the EKS cluster"
  value       = aws_eks_cluster.main.arn
}

# Exposes the Kubernetes API endpoint for cluster connectivity
output "cluster_endpoint" {
  description = "Endpoint of the EKS Kubernetes API server"
  value       = aws_eks_cluster.main.endpoint
}

# Exposes the cluster certificate authority data used to authenticate Kubernetes clients
output "cluster_certificate_authority_data" {
  description = "Base64-encoded certificate authority data for the EKS cluster"
  value       = aws_eks_cluster.main.certificate_authority[0].data
}

# Exposes the EKS cluster IAM role ARN for use by supporting infrastructure
output "cluster_role_arn" {
  description = "ARN of the IAM role used by the EKS control plane"
  value       = aws_iam_role.eks_cluster.arn
}

# Exposes the EKS OIDC issuer URL for IAM role trust policies
output "oidc_issuer_url" {
  description = "OIDC issuer URL associated with the EKS cluster"
  value       = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# Exposes the IAM OIDC provider ARN for Kubernetes service account roles
output "oidc_provider_arn" {
  description = "ARN of the IAM OIDC provider associated with the EKS cluster"
  value       = aws_iam_openid_connect_provider.eks.arn
}

# Exposes the AWS Load Balancer Controller IAM role ARN for Helm configuration
output "alb_controller_role_arn" {
  description = "ARN of the IAM role used by the AWS Load Balancer Controller"
  value       = aws_iam_role.alb_controller.arn
}

# Exposes the Cluster Autoscaler IAM role ARN for Helm configuration
output "cluster_autoscaler_role_arn" {
  description = "ARN of the IAM role used by the Cluster Autoscaler"
  value       = aws_iam_role.cluster_autoscaler.arn
}