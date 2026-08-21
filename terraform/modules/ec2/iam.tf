# Defines the trust policy that allows EC2 to assume the Jenkins IAM role
data "aws_iam_policy_document" "jenkins_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Creates the IAM role used by the Jenkins EC2 instance
resource "aws_iam_role" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-role"

  assume_role_policy = data.aws_iam_policy_document.jenkins_assume_role.json

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-role"
  }
}

# Defines permissions required for Jenkins to authenticate to and push images to ECR
data "aws_iam_policy_document" "jenkins_ecr" {

  # Allows Jenkins to retrieve an ECR authentication token
  statement {
    effect = "Allow"

    actions = [
      "ecr:GetAuthorizationToken"
    ]

    resources = ["*"]
  }

  # Allows Jenkins to push and inspect images in the application ECR repository
  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:BatchGetImage"
    ]

    resources = [
      var.ecr_repository_arn
    ]
  }
}

# Creates the IAM policy used by Jenkins for ECR access
resource "aws_iam_policy" "jenkins_ecr" {
  name        = "${var.project_name}-${var.environment}-jenkins-ecr-policy"
  description = "Allows Jenkins to authenticate to and push application images to ECR"

  policy = data.aws_iam_policy_document.jenkins_ecr.json

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-ecr-policy"
  }
}

# Attaches the ECR policy to the Jenkins IAM role
resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_ecr.arn
}

# Creates the instance profile used to attach the Jenkins IAM role to EC2
resource "aws_iam_instance_profile" "jenkins" {
  name = "${var.project_name}-${var.environment}-jenkins-instance-profile"
  role = aws_iam_role.jenkins.name

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-instance-profile"
  }
}

# Defines permissions required for Jenkins to discover the EKS cluster
data "aws_iam_policy_document" "jenkins_eks" {
  statement {
    effect = "Allow"

    actions = [
      "eks:DescribeCluster"
    ]

    resources = [
      "arn:aws:eks:us-east-1:236898858566:cluster/eks-project-Development-eks"
    ]
  }
}

# Creates the IAM policy used by Jenkins to access EKS cluster information
resource "aws_iam_policy" "jenkins_eks" {
  name        = "${var.project_name}-${var.environment}-jenkins-eks-policy"
  description = "Allows Jenkins to retrieve EKS cluster information for Kubernetes deployments"

  policy = data.aws_iam_policy_document.jenkins_eks.json

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-eks-policy"
  }
}

# Attaches the EKS access policy to the Jenkins IAM role
resource "aws_iam_role_policy_attachment" "jenkins_eks" {
  role       = aws_iam_role.jenkins.name
  policy_arn = aws_iam_policy.jenkins_eks.arn
}