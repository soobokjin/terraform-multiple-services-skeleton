variable "project_name" {
  description = "Company or project name"
  type        = string
  default     = "nx"
}

variable "created_by" {
  description = "Created by"
  type        = string
  default     = "terraform"
}

variable "stage" {
  description = "Environment (dev, prod)."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC which the subnet group belongs to."
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "(Optional) Specify true to indicate that instances launched into the subnet should be assigned a public IP address."
  type        = bool
  default     = false
}

variable "subnets" {
  description = "Subnet info"
  type        = map(map(any))
}
