variable "project_name" {
  description = "Company or project name"
  type        = string
  default     = "nx"
}

variable "stage" {
  description = "Environment (dev, production)."
  type        = string
}

variable "created_by" {
  description = "created by"
  type        = string
}


variable "vpc_id" {
  description = "The ID of the VPC which the subnet group belongs to."
  type        = string
}
