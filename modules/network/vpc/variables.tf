variable "project_name" {
  description = "Company or project name"
  type        = string
  default     = "nx"
}

variable "stage" {
  description = "Environment (dev, prod)."
  type        = string
}

variable "created_by" {
  description = "Created by"
  type        = string
  default     = "terraform"
}

variable "enable_dns_hostnames" {
  description = "Whether or not the VPC has DNS hostname support"
  type        = bool
  default     = false
}

variable "cidr_block" {
  description = "Cidr block of the desired VPC."
  type        = string
  default     = "0.0.0.0/0"
}