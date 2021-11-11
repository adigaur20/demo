#############################################################
## SC LB
#############################################################
resource "aws_lb_target_group" "app" {
  name     = "${var.tenant}-app"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${aws_vpc.default.id}"
  health_check {
    path     = "/health"
    protocol = "HTTP"
    port     = 8080
    matcher  = 200
  }
}
resource "aws_lb_target_group_attachment" "app" {
  target_group_arn = "${aws_lb_target_group.app.arn}"
  target_id        = "${aws_instance.app.*.id[0]}"
  port             = 443
}
resource "aws_lb" "app" {
  name               = "${var.tenant}-APP"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["${aws_security_group.applb.id}"]
  subnets            = ["${aws_subnet.dmz.*.id}"]

  #enable_deletion_protection = true
  tags {
    VPC = "${var.tenant}"
  }
}
resource "aws_lb_listener" "app" {
  count             = "${var.certsValid}"
  load_balancer_arn = "${aws_lb.app.arn}"
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS-1-2-2017-01"
  certificate_arn   = "${aws_acm_certificate.app.arn}"

  default_action {
    target_group_arn = "${aws_lb_target_group.app.arn}"
    type             = "forward"
  }
}