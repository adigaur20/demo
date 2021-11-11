### TO create SSl certificate for Application LB 

resource "aws_acm_certificate" "sc" {
  domain_name = "${var.app_fqdn}"
  validation_method = "DNS"
  tags {
    VPC = "${var.tenant}"
  }
  lifecycle {
    create_before_destroy = true
  }
}
