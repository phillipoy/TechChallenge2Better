# Creates the ECR repository used to store application container images
resource "aws_ecr_repository" "application" {
  name                 = "${lower(var.project_name)}-${lower(var.environment)}-app"
  image_tag_mutability = "MUTABLE"

  # Enables vulnerability scanning when container images are pushed
  image_scanning_configuration {
    scan_on_push = true
  }

  # Encrypts container images at rest using AWS-managed encryption
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-ecr"
  }
}