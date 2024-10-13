output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "execution_role_arn" {
  value = module.iam.execution_role_arn
}