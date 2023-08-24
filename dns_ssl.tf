// Data call to get information about DNS Public Zone that already exists in Route 53
data "aws_route53_zone" "kpa23_public_zone" {
  name = "kainos-platform-academy.com"
  private_zone = false

}

// Creation of an SSL certificate for HTTPS connections on the ALB, validated using DNS public zone
resource "aws_acm_certificate" "alb_cert" {
  domain_name       = "${aws_lb.alb.name}.${data.aws_route53_zone.kpa23_public_zone.name}"
  validation_method = "DNS"

  tags = {
    Environment = "instructor-alb-certificate"
  }

  lifecycle {
    create_before_destroy = true
  }
}

// Creation of the CNAME DNS record required to validate the new SSL certifcate against our Public DNS zone
resource "aws_route53_record" "alb_cert_ssl_record" {
  for_each = {
    for dvo in aws_acm_certificate.alb_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.kpa23_public_zone.zone_id
}

// Applys the validation of the ssl certificate that was created
resource "aws_acm_certificate_validation" "alb_cert_ssl_record_validiation" {
  certificate_arn         = aws_acm_certificate.alb_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.alb_cert_ssl_record : record.fqdn]
}

// Creation of the public DNS record that clients will browse to in chrome/firefox/safari/etc
resource "aws_route53_record" "alb_dns_record" {
  zone_id = data.aws_route53_zone.kpa23_public_zone.zone_id
  name    = "${aws_lb.alb.name}.${data.aws_route53_zone.kpa23_public_zone.name}" # OR "www.example.com"
  type    = "A"

  // Using an A record with an Alias to get the default ALB DNS name made by AWS on the ALB creation. Discovered bug in Terraform where certain regions miss the starting duelstack. You'd see that this is the correct name if you created this in Route 53 via clickops
  alias {
      name                   = "dualstack.${aws_lb.alb.dns_name}"
      zone_id                = aws_lb.alb.zone_id
      evaluate_target_health = true
  }
}
