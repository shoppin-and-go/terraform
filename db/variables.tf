variable "vpc_id" {
  description = "The ID of the VPC."
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet."
  type = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
}

variable "keypair_name" {
  description = "The name of the key pair to access for EC2 instances."
  type        = string
}

variable "mysql_database" {
  description = "The name of the MySQL database."
  type        = string
}

variable "mysql_root_password" {
  description = "The root password of the MySQL database."
  type        = string
}

variable "mysql_user" {
  description = "The user of the MySQL database."
  type        = string
}

variable "mysql_password" {
  description = "The password of the MySQL database."
  type        = string
}