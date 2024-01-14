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


variable "internal" {
  description = "(Optional) If true, the LB will be internal."
  type = bool
  default = false
}

variable "subnet_ids" {
  description = "List of subnet ids"
  type = list(string)
}


variable "sequrity_group_ids" {
  description = "List of sequrity group ids"  
  type = list(string)
}