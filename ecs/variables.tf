variable "vpc_id" {
  description = "The ID of the VPC."
  type = string
}

variable "subnet_id" {
  description = "The ID of the subnet."
  type = string
}

variable "execution_role_arn" {
  description = "The ARN of the ECS execution role."
  type = string
}

variable "cluster_name" {
  description = "The name of the ECS cluster."
  type        = string
}

variable "service_api_name" {
  description = "The name of the ECS service."
  type        = string
}

variable "image_repo_url" {
  description = "The URL of the ECR repository."
  type        = string
}

variable "keypair_name" {
  description = "The name of the key pair to access for EC2 instances."
  type        = string
}

variable "instance_type" {
  description = "The type of EC2 instance to launch."
  type        = string
}
