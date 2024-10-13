data "aws_ssm_parameter" "ecs_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2/arm64/recommended/image_id"
}

resource "aws_security_group" "ecs_instance" {
  name        = "ecs-instance-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
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
    Name = "ecs-on-ec2-sg"
  }
}

resource "aws_instance" "api_server" {
  ami                    = data.aws_ssm_parameter.ecs_ami.value
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [aws_security_group.ecs_instance.id]
  key_name               = var.keypair_name

  user_data = base64encode(templatefile("${path.module}/user-data.sh", {
    cluster_name = aws_ecs_cluster.main.name
  }))

  associate_public_ip_address = true

  iam_instance_profile = aws_iam_instance_profile.ecs_instance_profile.id

  tags = {
    Name = "ECS Instance"
  }
}

resource "aws_eip" "db_instance_eip" {
  vpc = true
  instance = aws_instance.api_server.id
}

output "api_server_host"  {
  value = aws_instance.api_server.public_dns
}
