output "name" {
  description = "The VPC name."
  value       = local.name
}

output "id" {
  description = "The ID of the VPC."
  value       = aws_vpc.this.id
}

output "arn" {
  description = "The ARN of the VPC."
  value       = aws_vpc.this.arn
}

output "cidr_block" {
  description = "The CIDR block of the VPC."
  value       = aws_vpc.this.cidr_block
}