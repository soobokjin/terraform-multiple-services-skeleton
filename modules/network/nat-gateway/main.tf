locals {

  common_tags = {
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}


resource "aws_eip" "this" {
  count = !var.is_private && var.assign_eip_on_create ? 1 : 0

  vpc = true

  tags = merge(
    {
      Name = "${var.stage}-${var.project_name}-nat-eip"
    },
    local.common_tags,
  )
}


resource "aws_nat_gateway" "this" {
  connectivity_type = var.is_private ? "private" : "public"
  subnet_id         = var.subnet_id
  allocation_id     = length(aws_eip.this) > 0 ? aws_eip.this[0].id : var.eip_id


  tags = merge(
    {
      Name = "${var.stage}-${var.project_name}-nat"
    },
    local.common_tags
  )
}