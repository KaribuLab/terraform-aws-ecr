# terraform-aws-ecr

Este módulo de Terraform permite crear repositorios ECR (Elastic Container Registry) en AWS de forma sencilla y configurable.

## Uso básico

```hcl
module "ecr" {
  source              = "github.com/patricio/terraform-aws-ecr"
  name                = "ecr-repository"
  image_tag_mutability = "MUTABLE"
  lifecycle_policy    = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "action": {
        "type": "expire"
      },
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      }
    }
  ]
}
EOF
  tags = {
    Name = "ecr-repository"
  }
}
```

## Uso con repository_policy (Lambda access)

```hcl
module "ecr_lambda" {
  source               = "github.com/patricio/terraform-aws-ecr"
  name                 = "lambda-ecr-repository"
  image_tag_mutability = "MUTABLE"

  # Política de acceso para Lambda
  repository_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "LambdaECRImageRetrievalPolicy"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
        Action = [
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer"
        ]
      }
    ]
  })

  lifecycle_policy = jsonencode({
    rules = [{
      rulePriority = 1
      description  = "Keep last 10 images"
      action = {
        type = "expire"
      }
      selection = {
        tagStatus   = "any"
        countType   = "imageCountMoreThan"
        countNumber = 10
      }
    }]
  })

  tags = {
    Name    = "lambda-ecr-repository"
    Service = "Lambda"
  }
}
```

## Variables de entrada

| Nombre              | Descripción                                      | Valor por defecto | Requerido |
| ------------------- | ------------------------------------------------ | ----------------- | --------- |
| name                | Nombre del repositorio ECR                       | n/a               | Sí        |
| image_tag_mutability| Política de mutabilidad de tags (MUTABLE/IMMUTABLE) | "MUTABLE"      | No        |
| lifecycle_policy    | Política de ciclo de vida del repositorio en JSON | n/a              | Sí        |
| repository_policy   | Política de repositorio JSON (permisos de acceso) | null             | No        |
| tags                | Etiquetas comunes para aplicar a los recursos    | n/a               | Sí        |

## Recursos creados

Este módulo crea los siguientes recursos:

- Repositorio ECR (`aws_ecr_repository`)
- Política de ciclo de vida del repositorio (`aws_ecr_lifecycle_policy`)
- Política de repositorio ECR (`aws_ecr_repository_policy`) - Opcional, solo si se especifica `repository_policy`

## Outputs

| Nombre             | Descripción                           |
| ------------------ | ------------------------------------- |
| ecr_repository_url | URL del repositorio ECR creado        |
| ecr_repository_arn | ARN del repositorio ECR creado        |

## Ejemplo de ejecución

```bash
terraform init
terraform apply
```

## Licencia

Este proyecto está licenciado bajo los términos de la licencia Apache 2.0. Consulta el archivo LICENSE para más detalles. 