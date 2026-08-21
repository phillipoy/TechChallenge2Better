# Registers the SSH public key used to securely access the Jenkins server
resource "aws_key_pair" "jenkins" {
  key_name   = "${var.project_name}-${var.environment}-jenkins-key"
  public_key = var.public_key

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins-key"
  }
}

# Creates the EC2 instance used to host the Jenkins CI/CD server
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.jenkins.key_name
  vpc_security_group_ids = var.security_group_ids

  # Associates the Jenkins IAM role with the EC2 instance
  iam_instance_profile = aws_iam_instance_profile.jenkins.name

  tags = {
    Name = "${var.project_name}-${var.environment}-jenkins"
  }
}

