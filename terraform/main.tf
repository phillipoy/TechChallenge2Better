# Deploys the networking layer used by EKS and supporting AWS resources
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Deploys the container registry used to store application images
module "ecr" {
  source = "./modules/ecr"

  project_name = var.project_name
  environment  = var.environment
}

# Deploys security groups used by supporting AWS resources
module "security_groups" {
  source = "./modules/security_groups"

  vpc_id             = module.vpc.vpc_id
  jenkins_admin_cidr = var.jenkins_admin_cidr
  project_name       = var.project_name
  environment        = var.environment
}

# Deploys the EC2 instance used to host the Jenkins CI/CD server
module "ec2" {
  source = "./modules/ec2"

  project_name = var.project_name
  environment  = var.environment

  ami_id        = "ami-0b6d9d3d33ba97d99"
  instance_type = "c7i-flex.large"

  # Deploys Jenkins into the first public subnet
  subnet_id = module.vpc.public_subnet_ids[0]

  # Associates the Jenkins security group with the EC2 instance
  security_group_ids = [
    module.security_groups.jenkins_security_group_id
  ]

  # Registers the locally generated SSH public key with AWS
  public_key = file(pathexpand("~/.ssh/techchallenge2-jenkins.pub"))

  # Restricts Jenkins image permissions to the application ECR repository
  ecr_repository_arn = module.ecr.repository_arn
}

# Deploys the EKS control plane within the private networking layer
module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids

  # Grants the Jenkins EC2 IAM role access to the EKS cluster
  jenkins_role_arn = module.ec2.jenkins_role_arn

  # Allows the Jenkins server to reach the private EKS API endpoint
  jenkins_security_group_id = module.security_groups.jenkins_security_group_id
}

# Deploys the managed worker node group used to run Kubernetes workloads
module "node_group" {
  source = "./modules/node_group"

  project_name       = var.project_name
  environment        = var.environment
  cluster_name       = module.eks.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids

  # Defines worker node compute and scaling requirements
  instance_type = "t3.small"
  min_size      = 1
  desired_size  = 1
  max_size      = 4
}