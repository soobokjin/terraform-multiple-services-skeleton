locals {
  name = "${var.stage}-${var.project_name}-vpc"

  common_tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}

resource "aws_vpc" "this" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(local.common_tags)
}