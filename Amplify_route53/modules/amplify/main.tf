resource "aws_amplify_app" "app" {
  name = var.project_name

  build_spec = <<-EOT
    version: 1
    frontend:
      phases:
        preBuild:
          commands:
            - npm ci --cache .npm --prefer-offline
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: dist
        files:
          - '**/*'
      cache:
        paths:
          - .npm/**/*
  EOT

  enable_auto_branch_creation = true


  # Redirect rules (SPA support)
  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  tags = {
    Name = "${var.env}-${var.project_name}"
  }
}

resource "aws_amplify_branch" "branch" {
  app_id      = aws_amplify_app.app.id
  branch_name = var.branch_name

  enable_auto_build = true

  framework = "React"
  stage     = "PRODUCTION"

}

resource "aws_amplify_domain_association" "domain_association" {
  app_id      = aws_amplify_app.app.id
  domain_name = var.domain_name

  sub_domain {
    branch_name = aws_amplify_branch.branch.branch_name
    prefix      = ""
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_amplify_domain_association.domain_association.certificate_verification_dns_record :
    dvo.name => {
      name  = dvo.name
      type  = dvo.type
      value = dvo.value
    }
  }
  zone_id = aws_route53_zone.main.zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.value]
  ttl     = 300
}