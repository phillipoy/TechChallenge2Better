# Creates the security group used by the Jenkins EC2 instance
resource "aws_security_group" "jenkins" {
  name        = "${var.project_name}-${var.environment}-jenkins-sg"
  description = "Controls inbound and outbound traffic for the Jenkins server"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-sg"
  }
}

# Allows administrative SSH access to the Jenkins server
resource "aws_vpc_security_group_ingress_rule" "jenkins_ssh" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = var.jenkins_admin_cidr
  from_port   = 22
  to_port     = 22
  ip_protocol = "tcp"

  description = "Allows SSH access from the trusted administrator network"
}

# Allows access to the Jenkins web interface
resource "aws_vpc_security_group_ingress_rule" "jenkins_web" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = var.jenkins_admin_cidr
  from_port   = 8080
  to_port     = 8080
  ip_protocol = "tcp"

  description = "Allows access to the Jenkins web interface"
}

# Allows Jenkins to reach AWS APIs, package repositories, and external services
resource "aws_vpc_security_group_egress_rule" "jenkins_egress" {
  security_group_id = aws_security_group.jenkins.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  description = "Allows outbound traffic from the Jenkins server"
}