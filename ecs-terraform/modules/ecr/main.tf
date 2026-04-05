resource "aws_ecr_repository" "flask-app-repo" {
  name                 = "${var.project-name}-${var.env}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}