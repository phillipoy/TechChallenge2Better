# Exposes the Jenkins IAM role ARN for EKS access configuration
output "jenkins_role_arn" {
  description = "ARN of the IAM role used by the Jenkins EC2 instance"
  value       = aws_iam_role.jenkins.arn
}

# Exposes the public IP address of the Jenkins server
output "jenkins_public_ip" {
  description = "Public IP address of the Jenkins EC2 instance"
  value       = aws_instance.jenkins.public_ip
}