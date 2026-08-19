# Exposes the EKS managed node group name for supporting infrastructure and automation
output "node_group_name" {
  description = "Name of the EKS managed node group"
  value       = aws_eks_node_group.main.node_group_name
}

# Exposes the worker node IAM role ARN for supporting AWS integrations
output "node_role_arn" {
  description = "ARN of the IAM role used by EKS worker nodes"
  value       = aws_iam_role.eks_nodes.arn
}

# Exposes the EKS managed node group ARN
output "node_group_arn" {
  description = "ARN of the EKS managed node group"
  value       = aws_eks_node_group.main.arn
}