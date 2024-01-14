output "id" {
  description = "Target group id"  
  value = aws_lb_target_group.this.id
}

output "arn" {
  description = "Target group arn"
  value = aws_lb_target_group.this.arn
}