output "id" {
  value = aws_instance.this.id
}

output "service_name" {
  value = var.service_name
}

output "ec2_name" {
  value = local.name
}

output "public_ip" {
  value = aws_instance.this.public_ip

    precondition {
    condition     = var.associate_public_ip_address
    error_message = "The server's root volume is not encrypted."
  }
}