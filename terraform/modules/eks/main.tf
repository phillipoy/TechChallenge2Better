# Creates the Amazon EKS cluster used to run Kubernetes workloads
resource "aws_eks_cluster" "main" {
  name     = "${var.project_name}-${var.environment}-eks"
  role_arn = aws_iam_role.eks_cluster.arn

  # Enables EKS access entries while preserving existing cluster administrator access
  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  # Configures the subnets and API endpoint access used by the EKS control plane
  vpc_config {
    subnet_ids = var.private_subnet_ids

    endpoint_private_access = true
    endpoint_public_access  = true
  }

  # Ensures required IAM permissions are attached before creating the cluster
  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-eks"
  }
}

# Allows the Jenkins server to communicate with the EKS API server over HTTPS
resource "aws_vpc_security_group_ingress_rule" "jenkins_to_eks_api" {
  security_group_id = aws_eks_cluster.main.vpc_config[0].cluster_security_group_id

  referenced_security_group_id = var.jenkins_security_group_id
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"

  description = "Allows Jenkins to access the EKS Kubernetes API"
}