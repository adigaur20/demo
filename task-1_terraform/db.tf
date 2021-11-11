### To create Postgres DB RDS

resource "aws_db_subnet_group" "dbsg" {
  subnet_ids = [ aws_subnet.data.*.ids ]

  tags = {
    VPC = var.tenant
    Name = "${var.tenant}-PostgresDB"
  }
}

resource "aws_db_instance" "db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "9.5" 
  instance_class        = "db.t2.micro"
  name                 = "db"
  username             = "dbuser"
  password             = "dbpassword"
  db_subnet_group_name      = aws_db_subnet_group.dbsg.name
  vpc_security_group_ids = [ aws_security_group.dbdb.id ]
  backup_window      = "00:00-01:00"
  backup_retention_period = 1
  tags {
    VPC = var.tenant
    Name = "${var.tenant}-PostgresDB"
  }
}
