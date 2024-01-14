variable "project_name" {
  description = ""
  type        = string
  default     = "noox"
}

variable "stage" {
  description = "Environment (dev, production)."
  type        = string
}

variable "created_by" {
  description = "created by"
  type        = string
}

variable "target_service_name" {
  description = "Target service name. (e.g. processor, web, etc)"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC which the subnet group belongs to."
  type        = string
}

variable "ingress_rules" {
  description = "(Optional) A list of ingress rules in a security group."
  type        = any
  default     = []
}

variable "egress_rules" {
  description = "(Optional) A list of egress rules in a security group."
  type        = any
  default     = []
}