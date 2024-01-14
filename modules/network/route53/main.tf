data "aws_route53_zone" "this" {
  name         = var.domain_name
  private_zone = false
}

resource "aws_route53_record" "this" {
  zone_id         = data.aws_route53_zone.this.zone_id
  name            = var.url_prefix != "" ? "${var.url_prefix}.${data.aws_route53_zone.this.name}" : data.aws_route53_zone.this.name
  type            = "A"
  allow_overwrite = var.allow_overwrite
  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
