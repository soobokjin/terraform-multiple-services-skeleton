output "id" {
  description = "The ARN of the load balancer (matches arn)."  
  value = aws_lb.this.id
}

output "dns_name" {
  description = "The DNS name of the load balancer."
  value = aws_lb.this.dns_name
}

output "zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  value = aws_lb.this.zone_id
}