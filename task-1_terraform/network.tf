# This file is for VPC, Subnets and routetables
resource "aws_vpc" "default" {
  cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true
  
}

#Create subnets
resource "aws_subnet" "dmz" {
  count             = "${length(var.dmz_networks)}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${element(var.dmz_networks, count.index)}"
  availability_zone = "${var.region}${var.az[count.index]}"
  tags = {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.region}${element(var.az, count.index)} DMZ"
  }
}
resource "aws_subnet" "app" {
  count             = "${length(var.app_networks)}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.app_networks[count.index]}"
  availability_zone = "${var.region}${var.az[count.index]}"
  tags = {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.region}${var.az[count.index]} APP"
  }
}
resource "aws_subnet" "data" {
  count             = "${length(var.data_networks)}"
  vpc_id            = "${aws_vpc.default.id}"
  cidr_block        = "${var.data_networks[count.index]}"
  availability_zone = "${var.region}${var.az[count.index]}"
  tags = {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.region}${var.az[count.index]} DATA"
  }
}

# Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    VPC = "${var.tenant}"
    Name = "${var.tenant}"
  }
}

####################################################
## DMZ ROUTE TABLE
####################################################
resource "aws_route_table" "dmz_route_table" {
  vpc_id = "${aws_vpc.default.id}"
  tags = {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.region} DMZ RT"
  }
}
resource "aws_route" "dmz_default" {
  route_table_id         = "${aws_route_table.dmz_route_table.id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.igw.id}"
}

resource "aws_route_table_association" "dmz_route_assoc" {
  count          = "${length(var.dmz_networks)}"
  subnet_id      = "${aws_subnet.dmz.*.id[count.index]}"
  route_table_id = "${aws_route_table.dmz_route_table.id}"
}

####################################################
## APP ROUTE TABLE
####################################################
resource "aws_route_table" "app_route_table" {
  vpc_id       = "${aws_vpc.default.id}"
  count        = "${length(var.app_networks)}"
  tags = {
    VPC = "${var.tenant}"
    Name = "${var.tenant} ${var.region}${var.az[count.index]} APP RT"
  }
}

resource "aws_route_table_association" "app_route_assoc" {
  count        = "${length(var.app_networks)}"
  subnet_id      = "${aws_subnet.app.*.id[count.index]}"
  route_table_id = "${aws_route_table.app_route_table.*.id[count.index]}"
}
resource "aws_route_table_association" "data_route_assoc" {
  count        = "${length(var.data_networks)}"
  subnet_id      = "${aws_subnet.data.*.id[count.index]}"
  route_table_id = "${aws_route_table.app_route_table.*.id[count.index]}"
}

