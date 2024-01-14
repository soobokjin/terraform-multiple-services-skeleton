locals {
  name = "${var.stage}-${var.project_name}-listener-rule"

  common_tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}

resource "aws_lb_listener_rule" "this" {
  listener_arn = var.listener_arn
  priority = var.priority

  dynamic "condition" {
    for_each = try(var.conditions, [])

    content {
      dynamic "path_pattern" {
        for_each = condition.value.type == "PATH" ? ["go"] : []

        content {
          values = condition.value.values
        }
      }
    }
  }

  dynamic "action" {
    for_each = (var.action_type == "FORWARD" ? [var.action_parameters] : [])

    content {
      type = "forward"
      target_group_arn = action.value.target_group_arn
    }
  }

  dynamic "action" {
    for_each = (var.action_type == "FIXED_RESPONSE"
      ? [var.action_parameters]
      : []
    )

    content {
      type = "fixed-response"

      fixed_response {
        status_code  = try(action.value.status_code, 503)
        content_type = try(action.value.content_type, "text/plain")
        message_body = try(action.value.data, "")
      }
    }
  }

  tags = merge(local.common_tags)
}

