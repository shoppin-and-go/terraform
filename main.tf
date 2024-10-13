
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

module "vpc" {
  source = "./vpc"
}

module "iam" {
  source = "./iam"
}

module "ecs" {
  source = "./ecs"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  execution_role_arn = module.iam.execution_role_arn

  cluster_name = "shoppin-and-go-cluster"
  service_api_name = "inventory-api"
  service_db_name = "inventory-db"
  image_repo_url = "public.ecr.aws/e6u1y0g6/shoppin-and-go/inventory-server:latest"
  keypair_name = "mkroo"
  instance_type = "t4g.nano"

  mysql_database = var.mysql_database
  mysql_root_password = var.mysql_root_password
  mysql_user = var.mysql_user
  mysql_password = var.mysql_password
}

output "ecs_cluster_id" {
  value = module.ecs.cluster_id
}

output "load_balancer_dns" {
  value = module.ecs.load_balancer_dns
}