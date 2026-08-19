# Creates the managed node group that provides worker nodes for the EKS cluster
resource "aws_eks_node_group" "main" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.project_name}-${var.environment}-node-group"
  node_role_arn   = aws_iam_role.eks_nodes.arn
  subnet_ids      = var.private_subnet_ids

  # Defines the EC2 instance type used by worker nodes
  instance_types = [
    var.instance_type
  ]

  # Configures the minimum, desired, and maximum number of worker nodes
  scaling_config {
    min_size     = var.min_size
    desired_size = var.desired_size
    max_size     = var.max_size
  }

  # Ensures required IAM permissions are attached before worker nodes are created
  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-node-group"
  }
}