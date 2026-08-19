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

# Deploys the EKS control plane within the private networking layer
module "eks" {
  source = "./modules/eks"

  project_name       = var.project_name
  environment        = var.environment
  private_subnet_ids = module.vpc.private_subnet_ids
}

# Deploys the managed worker node group used to run Kubernetes workloads
module "node_group" {
  source = "./modules/node_group"

  project_name       = var.project_name
  environment        = var.environment
  cluster_name       = module.eks.cluster_name
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type = "t3.small"
  min_size      = 1
  desired_size  = 1
  max_size      = 4
}