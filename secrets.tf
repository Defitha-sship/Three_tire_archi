#################################
# RANDOM PASSWORD
#################################

resource "random_password" "db_password" {

  length = 16

  special = true
}

#################################
# SECRET
#################################

resource "aws_secretsmanager_secret" "db_secret" {

  name = "${var.project_name}-db-secret-v2"

  tags = local.common_tags
}

#################################
# SECRET VALUE
#################################

resource "aws_secretsmanager_secret_version" "db_secret_value" {

  secret_id = aws_secretsmanager_secret.db_secret.id

  secret_string = jsonencode({

    username = "postgres"

    password = random_password.db_password.result
  })
}