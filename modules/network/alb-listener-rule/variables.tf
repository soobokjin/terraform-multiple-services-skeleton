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

variable "listener_arn" {
description = "(Required) Listener arn"
  type      = string
  nullable = false
}


variable "priority" {
  description = "(Required) The priority for the rule between 1 and 50000. Leaving it unset will automatically set the rule with next available priority after currently existing highest rule. A listener can't have multiple rules with the same priority."
  type        = number
  nullable = false
}

variable "conditions" {
  description = "A set of conditions of the rule. One or more condition blocks can be set per rule. Most condition types can only be specified once per rule except for `HTTP_HEADER` and `QUERY` which can be specified multiple times. All condition blocks must be satisfied for the rule to match. Each item of `conditions` block as defined below."
  type = list(object({type=string,values=list(string)}))
}

variable "action_type" {
  description = "(Required) The type of the routing action. Valid values are `FORWARD`, `WEIGHTED_FORWARD`, `FIXED_RESPONSE`, `REDIRECT_301` and `REDIRECT_302`"
  type        = string
  default = "FORWARD"
}

variable "action_parameters" {
  type        = any
  default = {}
}