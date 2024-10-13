resource "aws_security_group" "db_sg" {
  name        = "docker-db-sg"
  description = "Allow MySQL access"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "docker-db-sg"
  }
}

data "aws_ssm_parameter" "amazon_linux_2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-arm64-gp2"
}

resource "aws_instance" "db_server" {
  ami           = data.aws_ssm_parameter.amazon_linux_2_ami.value
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  key_name      = var.keypair_name
  associate_public_ip_address = true

  # EBS 볼륨 추가 (데이터 영속성)
  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    root_password = var.mysql_root_password
    database = var.mysql_database
    user = var.mysql_user
    password = var.mysql_password
  }))

  tags = {
    Name = "docker-db-server"
  }
}

resource "aws_eip" "db_instance_eip" {
  vpc = true
  instance = aws_instance.db_server.id
}
