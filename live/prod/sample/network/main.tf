locals {
  config = {
    local  = yamldecode(file(var.local_config_file))
    global = yamldecode(file(var.global_config_file))
  }
}

module "vpc" {
  source = "../../../../modules/network/vpc"

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  cidr_block           = local.config.local.vpc.cidr
  enable_dns_hostnames = local.config.local.vpc.enable_dns_hostnames
}

module "internet_gateway" {
  source = "../../../../modules/network/internet-gateway"

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  vpc_id = module.vpc.id
}

module "nat_gateway" {
  source = "../../../../modules/network/nat-gateway"

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  is_private           = false
  subnet_id            = module.subnet_groups["public"].subnets[0].id
  assign_eip_on_create = true
}

module "subnet_groups" {
  source = "../../../../modules/network/subnet-group"

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  vpc_id                  = module.vpc.id
  for_each                = local.config.local.subnet_groups
  map_public_ip_on_launch = try(each.value.map_public_ip_on_launch, false)

  subnets = {
    for idx, subnet in each.value.subnets : "${each.key}-${idx}" => {
      ip_type           = each.key
      cidr_block        = subnet.cidr
      availability_zone = subnet.availability_zone
    }
  }
}

module "public_route_table" {
  source = "../../../../modules/network/route-table"

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  ip_type = "public"
  vpc_id  = module.vpc.id

  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      gateway_id = module.internet_gateway.id
    },
  ]

  subnets = module.subnet_groups["public"].subnets
}


module "private_route_table" {
  source = "../../../../modules/network/route-table"

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  ip_type = "private"
  vpc_id  = module.vpc.id

  ipv4_routes = [
    {
      cidr_block = "0.0.0.0/0"
      nat_gateway_id = module.nat_gateway.id
    },
  ]

  subnets = module.subnet_groups["private"].subnets
}


module "security_group" {
  source = "../../../../modules/network/security-group"
  for_each = {
    for security_group in local.config.local.security_groups :
    security_group.target_service_name => security_group
  }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  target_service_name = each.value.target_service_name
  vpc_id              = module.vpc.id

  ingress_rules = [
    for idx, rule in each.value.ingress_rules :
    {
      id          = "${idx}"
      protocol    = rule.protocol
      from_port   = rule.from_port
      to_port     = rule.to_port
      cidr_blocks = rule.cidr_blocks
      description = rule.description
    }
  ]
  egress_rules = [
    for idx, rule in each.value.egress_rules :
    {
      id          = "${idx}"
      protocol    = rule.protocol
      from_port   = rule.from_port
      to_port     = rule.to_port
      cidr_blocks = rule.cidr_blocks
      description = rule.description
    }
  ]
}

module "alb" {
  source = "../../../../modules/network/alb"
  for_each = { for alb in local.config.local.alb : alb.name_suffix => alb }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = "${local.config.global.project_name}-${each.key}"

  internal = false

  subnet_ids = [for subnet in module.subnet_groups["public"].subnets : subnet.id]
  sequrity_group_ids = [module.security_group["alb"].id] 
}

module "alb_listener" {
  source = "../../../../modules/network/alb-listener"

  for_each = {
    for alb_listener in flatten([for alb in local.config.local.alb : [
      for listener in alb.alb_listners : {
        name_suffix = alb.name_suffix
        alb_listener = listener
      }]
    ]) : "${alb_listener.name_suffix}-${alb_listener.alb_listener.listener_name}" => alb_listener
  }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  port = each.value.alb_listener.port
  protocol = each.value.alb_listener.protocol
  certificate_arn = try(each.value.alb_listener.certificate_arn, null)
  default_action_type = each.value.alb_listener.default_action_type

  alb_arn = module.alb[each.value.name_suffix].id
}

module "route53" {
  source = "../../../../modules/network/route53"
  for_each = {
    for hosted_zone in flatten([
      for domain in local.config.local.route53 : [
        for sub_domain in domain.sub_domains : {
          domain = domain.domain
          sub_domain = sub_domain.sub_domain
          mapping_alb_name_suffix = sub_domain.mapping_alb_name_suffix
        }
      ]
    ]) : hosted_zone.domain => domain
  }

  domain_name = each.key
  url_prefix = each.value.sub_domain

  alb_dns_name = module.alb[each.value.mapping_alb_name_suffix].dns_name
  alb_zone_id = module.alb[each.value.mapping_alb_name_suffix].zone_id
  allow_overwrite = true
}

