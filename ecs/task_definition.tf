resource "aws_cloudwatch_log_group" "ecs_api_log_group" {
  name              = "/ecs/shoppin-and-go-api-task"
  retention_in_days = 3
}

data "aws_ssm_parameter" "mysql_host" {
  name = "/shoppin-and-go/mysql/host"
}

data "aws_ssm_parameter" "mysql_database" {
  name = "/shoppin-and-go/mysql/database"
}

data "aws_ssm_parameter" "mysql_user" {
  name = "/shoppin-and-go/mysql/user"
}

data "aws_ssm_parameter" "mysql_password" {
  name = "/shoppin-and-go/mysql/password"
  with_decryption = true
}

resource "aws_ecs_task_definition" "api" {
  family                   = "shoppin-and-go-api-task"
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "400"

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "application"
      image     = var.image_repo_url
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group" = aws_cloudwatch_log_group.ecs_api_log_group.name
          "awslogs-region" = "ap-northeast-2"
          "awslogs-stream-prefix" = "ecs"
        }
      }
      environment = [
        {
          name  = "SPRING_PROFILES_ACTIVE"
          value = "dev"
        },
        {
          name = "SERVER_PORT"
          value = "80"
        },
        {
          name  = "SPRING_DATASOURCE_URL"
          value = "jdbc:mysql://${data.aws_ssm_parameter.mysql_host.value}:3306/${data.aws_ssm_parameter.mysql_database.value}?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8"
        },
      ]
      secrets = [
        {
          name      = "SPRING_DATASOURCE_PASSWORD"
          valueFrom = data.aws_ssm_parameter.mysql_password.arn
        },
        {
          name      = "SPRING_DATASOURCE_USERNAME"
          valueFrom = data.aws_ssm_parameter.mysql_user.arn
        },
      ]
      essential = true
    }
  ])
}

