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
  description = "vpc_id"
  type = string
  nullable = false
}

variable "instance_ids" {
  description = " (Required) The ID of the target. This is the Instance ID for an instance, or the container ID for an ECS container. "
  type = list(string)
  nullable = false
}

variable "port" {
  description = "(Required) The port on which targets receive traffic."
  type = number
  nullable = false
}

variable "target_type" {
  type = string
  default = "instance"
}


variable "health_check" {
  type = any
  nullable = true
}