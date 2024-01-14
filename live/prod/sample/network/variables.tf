variable "global_config_file" {
  description = "Global config file path"
  type        = string
  default     = "../global-config.yaml"
}

variable "local_config_file" {
  description = "Local config file path"
  type        = string
  default     = "./local-config.yaml"
}

variable "aws_profile" {
  description = "AWS profile to use"
  type        = string
  default     = "default"
}