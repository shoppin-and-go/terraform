
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

module "db" {
  source = "./db"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id

  instance_type = "t4g.micro"
  keypair_name = "mkroo"

  mysql_database = var.mysql_database
  mysql_root_password = var.mysql_root_password
  mysql_user = var.mysql_user
  mysql_password = var.mysql_password

  depends_on = [module.vpc]
}


module "ecs" {
  source = "./ecs"

  vpc_id = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id

  cluster_name = "shoppin-and-go-cluster"
  service_api_name = "inventory-api"
  image_repo_url = "public.ecr.aws/e6u1y0g6/shoppin-and-go/inventory-server:latest"
  execution_role_arn = module.iam.execution_role_arn

  instance_type = "t4g.micro"
  keypair_name = "mkroo"

  depends_on = [module.vpc, module.db]
}
