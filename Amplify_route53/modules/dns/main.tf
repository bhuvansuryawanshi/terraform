resource "aws_route53_zone" "app_zone" {
  name = var.domain_name

  tags = {
    Environment = var.env
  }
}



resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.app_zone.zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = var.amplify_domain_dns[0]
    zone_id                = var.zone_id
    evaluate_target_health = false
  }
}
