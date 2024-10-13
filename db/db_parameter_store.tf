resource "aws_ssm_parameter" "mysql_host" {
  name  = "/shoppin-and-go/mysql/host"
  type  = "String"
  value = aws_instance.db_server.public_ip
  overwrite = true
}

resource "aws_ssm_parameter" "mysql_database" {
  name  = "/shoppin-and-go/mysql/database"
  type  = "String"
  value = var.mysql_database
  overwrite = true
}

resource "aws_ssm_parameter" "mysql_user" {
  name  = "/shoppin-and-go/mysql/user"
  type  = "String"
  value = var.mysql_user
  overwrite = true
}

resource "aws_ssm_parameter" "mysql_password" {
  name  = "/shoppin-and-go/mysql/password"
  type  = "SecureString"
  value = var.mysql_password
  overwrite = true
}

resource "aws_ssm_parameter" "mysql_root_password" {
  name  = "/shoppin-and-go/mysql/root_password"
  type  = "SecureString"
  value = var.mysql_root_password
  overwrite = true
}
