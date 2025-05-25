resource "aws_ecr_repository" "" {
  count = var.create_ecr_repository ? 1 : 0

  name = var.ecr_repository_name != null ? var.ecr_repository_name : "${var.pipeline_name}-image"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Pipeline = var.pipeline_name
  }
}


resource "aws_ecr_repository" "" {
  count = var.create_ecr_repository ? 1 : 0

  name = var.ecr_repository_name != null ? var.ecr_repository_name : "${var.pipeline_name}-image"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Pipeline = var.pipeline_name
  }
}


