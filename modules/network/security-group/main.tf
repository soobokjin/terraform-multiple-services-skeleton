locals {
  normalized_ingress_rules = [
    for rule in var.ingress_rules : {
      id          = rule.id
      description = lookup(rule, "description", "Managed by Terraform")

      protocol  = rule.protocol
      from_port = rule.from_port
      to_port   = rule.to_port

      cidr_blocks              = try(sort(compact(rule.cidr_blocks)), null)
      ipv6_cidr_blocks         = try(sort(compact(rule.ipv6_cidr_blocks)), null)
      prefix_list_ids          = try(sort(compact(rule.prefix_list_ids)), null)
      source_security_group_id = try(rule.source_security_group_id, null)
      self                     = try(rule.self, false) ? true : null
    }
  ]
  normalized_egress_rules = [
    for rule in var.egress_rules : {
      id          = rule.id
      description = lookup(rule, "description", "Managed by Terraform")

      protocol  = rule.protocol
      from_port = rule.from_port
      to_port   = rule.to_port

      cidr_blocks              = try(sort(compact(rule.cidr_blocks)), null)
      ipv6_cidr_blocks         = try(sort(compact(rule.ipv6_cidr_blocks)), null)
      prefix_list_ids          = try(sort(compact(rule.prefix_list_ids)), null)
      source_security_group_id = try(rule.source_security_group_id, null)
      self                     = try(rule.self, false) ? true : null
    }
  ]
  name = "${var.stage}-${var.project_name}-${var.target_service_name}-sg"

  tags = {
    Name      = local.name
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}


resource "aws_security_group" "this" {
  vpc_id = var.vpc_id

  name = local.name

  tags = merge(
    local.tags
  )
}


resource "aws_security_group_rule" "ingress" {
  for_each = {
    for rule in local.normalized_ingress_rules :
    rule.id => rule
  }

  security_group_id = aws_security_group.this.id
  type              = "ingress"
  description       = each.value.description

  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
}

resource "aws_security_group_rule" "egress" {
  for_each = {
    for rule in local.normalized_egress_rules :
    rule.id => rule
  }

  security_group_id = aws_security_group.this.id
  type              = "egress"
  description       = each.value.description

  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  cidr_blocks              = each.value.cidr_blocks
  ipv6_cidr_blocks         = each.value.ipv6_cidr_blocks
  prefix_list_ids          = each.value.prefix_list_ids
  source_security_group_id = each.value.source_security_group_id
  self                     = each.value.self
}
