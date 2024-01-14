

variable "domain_name" {
  default = ""
  type        = string
}

variable "url_prefix" {
  default     = ""
  type        = string
}

variable "alb_dns_name" {
  description = "The DNS name of the load balancer."
  type = string
}

variable "alb_zone_id" {
  description = "The canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)."
  type =string  
}

variable "allow_overwrite" {
  description = "Allow creation of this record in Terraform to overwrite an existing record, if any."
  type        = bool
  default     = false
}