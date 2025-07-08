resource "aws_ecr_repository" "ecr" {
  name = var.name
  image_tag_mutability = var.image_tag_mutability
  tags = var.tags
}

resource "aws_ecr_lifecycle_policy" "ecr" {
  repository = aws_ecr_repository.ecr.name
  policy = var.lifecycle_policy
}