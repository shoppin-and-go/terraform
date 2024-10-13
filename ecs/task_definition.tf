resource "aws_ecs_task_definition" "api" {
  family                   = "shoppin-and-go-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

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
          value = "jdbc:mysql://database:3306/${var.mysql_database}?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&characterEncoding=UTF-8"
        },
        {
          name  = "SPRING_DATASOURCE_USERNAME"
          value = var.mysql_user
        },
        {
          name  = "SPRING_DATASOURCE_PASSWORD"
          value = var.mysql_password
        }
      ]
      essential = true
    }
  ])
}

resource "aws_ecs_task_definition" "db" {
  family                   = "shoppin-and-go-db-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = "256"
  memory                   = "512"

  execution_role_arn = var.execution_role_arn

  container_definitions = jsonencode([
    {
      name = "database",
      image = "mysql:8.0.39",
      portMappings = [
        {
          containerPort = 3306
          hostPort      = 3306
        }
      ],
      environment = [
        {
          name  = "MYSQL_DATABASE"
          value = var.mysql_database
        },
        {
          name  = "MYSQL_ROOT_PASSWORD"
          value = var.mysql_root_password
        },
        {
          name  = "MYSQL_USER"
          value = var.mysql_user
        },
        {
          name  = "MYSQL_PASSWORD"
          value = var.mysql_password
        }
      ],
      essential = true,
    }
  ])
}