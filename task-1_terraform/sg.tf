### to create SG rules for EC2 instance and DB 

####################################################
## BASTION
####################################################
resource "aws_security_group" "bastion" {
  name        = "${var.tenant}_BASTION"
  description = "SG for bastion hosts"
  vpc_id      = "${aws_vpc.default.id}"
}
resource "aws_security_group_rule" "bastion_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "Allow All"
  security_group_id        = "${aws_security_group.bastion.id}"
}

resource "aws_security_group_rule" "bastion_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  cidr_blocks              = "${var.ssh_allowed}"
  description              = "SSH access"
  security_group_id        = "${aws_security_group.bastion.id}"
}

####################################################
## APP
####################################################
resource "aws_security_group" "app" {
  name        = "${var.tenant}_APP"
  description = "SG for app hosts"
  vpc_id      = "${aws_vpc.default.id}"
}
resource "aws_security_group_rule" "app_egress" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = -1
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "Allow All"
  security_group_id        = "${aws_security_group.app.id}"
}
resource "aws_security_group_rule" "app_icmp" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  cidr_blocks              = ["${var.vpc_cidr}"]
  description              = "allow ICMP"
  security_group_id        = "${aws_security_group.app.id}"
}
resource "aws_security_group_rule" "app_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.dmz.id}"
  description              = "SSH access from Bastion"
  security_group_id        = "${aws_security_group.app.id}"
}


resource "aws_security_group_rule" "app_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.applb.id}"
  description              = "app access from LB"
  security_group_id        = "${aws_security_group.app.id}"
}


####################################################
## DMZ
####################################################
resource "aws_security_group" "dmz" {
  name        = "${var.tenant}_DMZ"
  description = "SG for dmz hosts"
  vpc_id      = "${aws_vpc.default.id}"
}

resource "aws_security_group_rule" "dmz_app_3128" {
  type                     = "ingress"
  from_port                = 3128
  to_port                  = 3128
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.app.id}"
  description              = "Web proxy access from APP instances"
  security_group_id        = "${aws_security_group.dmz.id}"
}

resource "aws_security_group_rule" "dmz_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = ["1.1.1.1/32"] #Local laptop public IP for SSH access
  description              = "SSH access from Bastion"
  security_group_id        = "${aws_security_group.app.id}"
}


####################################################
## APP LB
####################################################
resource "aws_security_group" "applb" {
  name        = "${var.tenant}_APP_LB"
  description = "SG for APP load balancer"
  vpc_id      = "${aws_vpc.default.id}"
}

resource "aws_security_group_rule" "applb_egress_icmp" {
  type                     = "egress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  source_security_group_id = "${aws_security_group.dmz.id}"
  description              = "Allow ICMP"
  security_group_id        = "${aws_security_group.applb.id}"
}
resource "aws_security_group_rule" "applb_443" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "HTTPS access from web"
  security_group_id        = "${aws_security_group.applb.id}"
}
resource "aws_security_group_rule" "applb_icmp" {
  type                     = "ingress"
  from_port                = -1
  to_port                  = -1
  protocol                 = "icmp"
  cidr_blocks              = ["0.0.0.0/0"]
  description              = "Allow ICMP"
  security_group_id        = "${aws_security_group.applb.id}"
}


####################################################
##  postgres DB
####################################################
resource "aws_security_group" "db" {
  name        = "${var.tenant}_db"
  description = "SG postgres db "
  vpc_id      = "${aws_vpc.default.id}"
}
resource "aws_security_group_rule" "db_5432" {
  type                     = "ingress"
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = "${aws_security_group.app.id}"
  description              = "connection from app to db instance"
  security_group_id        = "${aws_security_group.db.id}"
}
