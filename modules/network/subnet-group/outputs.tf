output "vpc_id" {
  description = "The ID of the VPC which the subnet group belongs to."
  value       = var.vpc_id
}

output "ids" {
  description = "A list of IDs of subnets"
  value       = values(aws_subnet.this)[*].id
}

output "arns" {
  description = "A list of ARNs of subnets"
  value       = values(aws_subnet.this)[*].arn
}

output "cidr_blocks" {
  description = "The CIDR blocks of the subnet group."
  value       = values(aws_subnet.this)[*].cidr_block
}

output "availability_zones" {
  description = "A list of availability zones which the subnet group uses."
  value       = local.availability_zones
}

output "availability_zone_ids" {
  description = "A list of availability zone IDs which the subnet group uses."
  value       = local.availability_zone_ids
}

output "subnets" {
  description = "A list of subnets of the subnet group."
  value       = local.subnets
}
