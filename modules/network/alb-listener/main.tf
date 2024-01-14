locals {
  name = "${var.stage}-${var.project_name}-listener"

  common_tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }

  tls_enabled        = var.protocol == "HTTPS"
}


resource "aws_lb_listener" "this" {

  load_balancer_arn = var.alb_arn
  port              = var.port
  protocol          = var.protocol
  certificate_arn   = local.tls_enabled ? var.certificate_arn : null

  dynamic "default_action" {
    for_each = (var.default_action_type == "FORWARD"
      ? [var.default_action_parameters]
      : []
    )
    content {
      type = "forward"
      target_group_arn = default_action.value.target_group_arn
    }
  }


  dynamic "default_action" {
    for_each = (var.default_action_type == "REDIRECT_301"
      ? [var.default_action_parameters]
      : []
    )

    content {
      type = "redirect"

      redirect {
        port        = "433"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

    dynamic "default_action" {
    for_each = (var.default_action_type == "FIXED_RESPONSE"
      ? [var.default_action_parameters]
      : []
    )

    content {
      type = "fixed-response"

      fixed_response {
        status_code  = try(default_action.value.status_code, 503)
        content_type = try(default_action.value.content_type, "text/plain")
        message_body = try(default_action.value.message_body, "Target group has not been set.")
      }
    }
  }

  tags = merge(local.common_tags)
}

