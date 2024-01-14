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

variable "alb_arn" {
description = "(Required) ALB arn"
  type      = string  
  nullable = false
}

variable "port" {
  description = "(Required) The number of port on which the listener of load balancer is listening."
  type        = number
  nullable    = false
}

variable "protocol" {
  description = "(Required) The protocol for connections from clients to the load balancer. Valid values are `HTTP` and `HTTPS`."
  type        = string
  nullable    = false

  validation {
    condition     = contains(["HTTP", "HTTPS"], var.protocol)
    error_message = "Valid values are `HTTP` and `HTTPS`."
  }
}

variable "certificate_arn" {
  description = "(Optional) The ARN of the default SSL server certificate. For adding additional SSL certificates, see the `tls_additional_certificates` variable. Required if `protocol` is `HTTPS`."
  type        = string
  default     = null
}

variable "default_action_type" {
  description = "(Required) The type of default routing action. Default action apply to traffic that does not meet the conditions of rules on your listener. Rules can be configured after the listener is created. Valid values are `FORWARD, `REDIRECT_301`."
  type        = string
  default = "FIXED_RESPONSE"
}

variable "default_action_parameters" {
  type        = any
  default = {}
}
