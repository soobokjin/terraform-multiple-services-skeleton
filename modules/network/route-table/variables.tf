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

variable "vpc_id" {
  description = "The ID of the VPC which the subnet group belongs to."
  type        = string
}

variable "ip_type" {
  description = "Public or Private"
  type        = string
}

variable "ipv4_routes" {
  description = "A list of route rules for IPv4 CIDRs."
  type        = list(map(string))
  default     = []
}


variable "subnets" {
  description = "Subnets"
  type        = list(map(any))
}
