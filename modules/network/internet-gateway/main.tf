locals {
  name = "${var.stage}-${var.project_name}-gw"

  common_tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}

resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id

  tags = merge(local.common_tags)
}
