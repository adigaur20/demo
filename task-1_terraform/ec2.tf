#### To create EC2 instances 

####################################################
## SSH KEY PAIR
####################################################
resource "aws_key_pair" "key" {
  key_name   = "${lower(var.tenant)}"
  public_key = "${var.pubkey}"
}

####################################################
## DMZ instances
####################################################
resource "aws_instance" "dmz" {
  count                  = "${length(var.dmz_instances)}"
  ami                    = "${var.ami_id}"
  instance_type          = "${var.dmz_instance_type[count.index]}"
  key_name               = "${aws_key_pair.key.key_name}"
  availability_zone      = "${var.region}${var.az[0]}"
  monitoring             = "true"
  vpc_security_group_ids = [ "${aws_security_group.dmz.id}" ]

  subnet_id  = "${aws_subnet.dmz.*.id[0]}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
  tags {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.dmz_instances[count.index]}"
  }
}
# Create Elastic IPs
resource "aws_eip" "dmz" {
  count    = "${length(var.dmz_instances)}"
  instance = "${aws_instance.dmz.*.id[count.index]}"
  vpc      = true
  tags {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.dmz_instances[count.index]}"
  }
}

####################################################
## App instances
####################################################
resource "aws_instance" "app" {
  count                  = "${length(var.app_instances)}"
  ami                    = "${var.ami_id}"
  instance_type          = "${var.app_instance_type[count.index]}"
  key_name               = "${aws_key_pair.key.key_name}"
  availability_zone      = "${var.region}${var.az[0]}"
  monitoring             = "true"
  vpc_security_group_ids = [ "${aws_security_group.app.id}" ]

  subnet_id  = "${aws_subnet.app.*.id[0]}"
  root_block_device {
    volume_type = "gp2"
    volume_size = "20"
  }
  tags {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.app_instances[count.index]}"
  }
}

