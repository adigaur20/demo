### TO create SSl certificate for Application LB 

resource "aws_acm_certificate" "app" {
  domain_name = "${var.app_fqdn}"
  validation_method = "DNS"
  tags {
    VPC = "${var.tenant}"
  }
  lifecycle {
    create_before_destroy = true
  }
}
