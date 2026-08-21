# Defines the trust policy that allows Amazon EKS to assume the cluster IAM role
data "aws_iam_policy_document" "eks_cluster_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Creates the IAM role used by the EKS control plane
resource "aws_iam_role" "eks_cluster" {
  name = "${var.project_name}-${var.environment}-eks-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.eks_cluster_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-cluster-role"
  }
}

# Grants the EKS control plane permissions required to manage AWS resources
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Retrieves the TLS certificate used by the EKS OIDC issuer
data "tls_certificate" "eks_oidc" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# Creates the IAM OIDC provider used by Kubernetes service accounts to assume AWS IAM roles
resource "aws_iam_openid_connect_provider" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    data.tls_certificate.eks_oidc.certificates[0].sha1_fingerprint
  ]

  tags = {
    Name = "${var.project_name}-${var.environment}-eks-oidc"
  }
}

# Retrieves the current AWS account ID for IAM policy configuration
data "aws_caller_identity" "current" {}

# Removes the HTTPS prefix from the EKS OIDC issuer URL for IAM trust policy conditions
locals {
  oidc_provider_url = replace(
    aws_eks_cluster.main.identity[0].oidc[0].issuer,
    "https://",
    ""
  )
}

# Defines the trust policy that allows the AWS Load Balancer Controller
# Kubernetes service account to assume its IAM role
data "aws_iam_policy_document" "alb_controller_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    # Restricts role assumption to the AWS Load Balancer Controller service account
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:sub"

      values = [
        "system:serviceaccount:kube-system:aws-load-balancer-controller"
      ]
    }

    # Requires the Kubernetes service account token to be intended for AWS STS
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

# Creates the IAM role used by the AWS Load Balancer Controller
resource "aws_iam_role" "alb_controller" {
  name = "${var.project_name}-${var.environment}-alb-controller-role"

  assume_role_policy = data.aws_iam_policy_document.alb_controller_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-controller-role"
  }
}

# Creates the IAM policy required by the AWS Load Balancer Controller
resource "aws_iam_policy" "alb_controller" {
  name        = "${var.project_name}-${var.environment}-alb-controller-policy"
  description = "Permissions required by the AWS Load Balancer Controller"

  policy = file("${path.module}/alb_controller_policy.json")

  tags = {
    Name = "${var.project_name}-${var.environment}-alb-controller-policy"
  }
}

# Attaches the AWS Load Balancer Controller policy to its IAM role
resource "aws_iam_role_policy_attachment" "alb_controller" {
  role       = aws_iam_role.alb_controller.name
  policy_arn = aws_iam_policy.alb_controller.arn
}

# Defines the trust policy that allows the Cluster Autoscaler
# Kubernetes service account to assume its IAM role
data "aws_iam_policy_document" "cluster_autoscaler_assume_role" {
  statement {
    effect = "Allow"

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.eks.arn
      ]
    }

    # Restricts role assumption to the Cluster Autoscaler service account
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:sub"

      values = [
        "system:serviceaccount:kube-system:cluster-autoscaler"
      ]
    }

    # Requires the service account token to be intended for AWS STS
    condition {
      test     = "StringEquals"
      variable = "${local.oidc_provider_url}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
  }
}

# Creates the IAM role used by the Cluster Autoscaler
resource "aws_iam_role" "cluster_autoscaler" {
  name = "${var.project_name}-${var.environment}-cluster-autoscaler-role"

  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster-autoscaler-role"
  }
}

# Defines AWS permissions required by the Cluster Autoscaler
data "aws_iam_policy_document" "cluster_autoscaler" {

  # Allows the autoscaler to modify the capacity of managed Auto Scaling groups
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup"
    ]

    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/enabled"
      values   = ["true"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/k8s.io/cluster-autoscaler/${aws_eks_cluster.main.name}"
      values   = ["owned"]
    }
  }

  # Allows the autoscaler to discover node groups and inspect EC2 instance capabilities
  statement {
    effect = "Allow"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeScalingActivities",
      "autoscaling:DescribeTags",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:GetInstanceTypesFromInstanceRequirements",
      "eks:DescribeNodegroup"
    ]

    resources = ["*"]
  }
}

# Creates the IAM policy required by the Cluster Autoscaler
resource "aws_iam_policy" "cluster_autoscaler" {
  name        = "${var.project_name}-${var.environment}-cluster-autoscaler-policy"
  description = "Permissions required by the Kubernetes Cluster Autoscaler"

  policy = data.aws_iam_policy_document.cluster_autoscaler.json

  tags = {
    Name = "${var.project_name}-${var.environment}-cluster-autoscaler-policy"
  }
}

# Attaches the Cluster Autoscaler policy to its IAM role
resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  role       = aws_iam_role.cluster_autoscaler.name
  policy_arn = aws_iam_policy.cluster_autoscaler.arn
}

# Grants the Jenkins IAM role authentication access to the EKS cluster
resource "aws_eks_access_entry" "jenkins" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.jenkins_role_arn
  type          = "STANDARD"

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-eks-access"
  }
}

# Grants Jenkins cluster-level Kubernetes permissions required for CI/CD deployments
resource "aws_eks_access_policy_association" "jenkins" {
  cluster_name  = aws_eks_cluster.main.name
  principal_arn = var.jenkins_role_arn

  policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"

  access_scope {
    type = "cluster"
  }

  depends_on = [
    aws_eks_access_entry.jenkins
  ]
}