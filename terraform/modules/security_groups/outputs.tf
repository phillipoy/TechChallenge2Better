# Exposes the Jenkins security group ID for use by the EC2 module
output "jenkins_security_group_id" {
  description = "ID of the security group used by the Jenkins server"
  value       = aws_security_group.jenkins.id
}