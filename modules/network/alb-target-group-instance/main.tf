locals {
  name = "${var.stage}-${var.project_name}-tg"

  common_tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}


resource "aws_lb_target_group" "this" {
  name     = local.name
  vpc_id   = var.vpc_id
  target_type = var.target_type
  port = var.target_type == "instance" ? var.port : null
  protocol = var.target_type == "instance" ? "HTTP" : null
  tags = merge(local.common_tags)

  dynamic "health_check" {
    for_each = (var.health_check != null ? [var.health_check] : [])

    content {
      enabled             = try(health_check.value.enabled, true)
      interval            = try(health_check.value.interval, 30)
      path                = try(health_check.value.path, "/api/v1")
      healthy_threshold   = try(health_check.value.healthy_threshold, 5)
      unhealthy_threshold = try(health_check.value.unhealthy_threshold, 2)
      timeout             = try(health_check.value.timeout, 5)
      protocol            = try(health_check.value.protocol, "HTTP")
    }
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count  = length(var.instance_ids)

  target_group_arn = aws_lb_target_group.this.arn
  target_id        = var.instance_ids[count.index]
  port             = var.port
}
