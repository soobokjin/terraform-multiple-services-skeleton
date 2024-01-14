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
  description = "Created by"
  type        = string
}

variable "service_name" {
  description = "Service name"
  type        = string
}

variable "ami_name" {
  description = "AMI Name to use"
  type        = string
  nullable = true
}

variable "owners" {
  description = "AMI owners"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "The instance type to use for the instance."
  type        = string
}

variable "associate_public_ip_address" {
  description = "Whether to associate a public IP address with an instance in a VPC"
  type        = bool
  default     = false
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance"
  type        = string
}

variable "availability_zone" {
  description = "AZ to start the instance in."
  type        = string
  default     = ""
}

variable "ebs_block_device" {
}

variable "subnet_id" {
  description = "The ID of the subnet which the NAT Gateway belongs to."
  type        = string
}

variable "security_groups" {
  description = "A list of security group names to associate with."
  type        = list(string)
}
