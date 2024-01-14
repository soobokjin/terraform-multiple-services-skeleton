output "vpc_id" {
  description = "The ID of the VPC."
  value = module.vpc.id
}

output "alb_listener_arns" {
  description = "Listener arns of alb"
  value = {for key, listener in module.alb_listener : key => listener.arn }
}

output "subnet_groups" {
  description = "Subnet group mudules"
  value = module.subnet_groups
}

output "security_group" {
  description = "sequrity_group"
  value = module.security_group
}