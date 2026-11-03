#################################
# DB SUBNET GROUP
#################################

resource "aws_db_subnet_group" "db_subnet_group" {

  name = "postgres-subnet-group"

  subnet_ids = [
    aws_subnet.private_db.id,
    aws_subnet.private_db_2.id
  ]

  tags = merge(
    local.common_tags,
    {
      Name = "postgres-subnet-group"
    }
  )
}
#################################
# POSTGRESQL RDS
#################################

resource "aws_db_instance" "postgres" {

  identifier = "postgres-db"

  engine = "postgres"

  engine_version = "16"

  instance_class = "db.t3.micro"

  allocated_storage = 20

  storage_type = "gp3"

  storage_encrypted = true

  username = "postgres"

  password = random_password.db_password.result

  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name

  vpc_security_group_ids = [
    aws_security_group.rds_sg.id
  ]

  publicly_accessible = false

  skip_final_snapshot = true

  deletion_protection = false

  backup_retention_period = 0

  tags = merge(
    local.common_tags,
    {
      Name = "postgres-db"
    }
  )
}