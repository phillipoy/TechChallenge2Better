# No standalone IAM resources are required for the ECR module
#
# Permissions to pull container images from ECR will be assigned to the EKS worker node IAM role in the node group module.