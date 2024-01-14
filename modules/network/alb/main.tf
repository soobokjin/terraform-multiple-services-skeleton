locals {
  name = "${var.stage}-${var.project_name}-alb"

  common_tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}


resource "aws_lb" "this" {
  name  = local.name
  internal = var.internal
  load_balancer_type = "application"
  
  security_groups = var.sequrity_group_ids
  subnets = var.subnet_ids

  enable_deletion_protection = false

  tags = merge(local.common_tags)
}