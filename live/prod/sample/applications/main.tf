locals {
  config = {
    local  = yamldecode(file(var.local_config_file))
    global = yamldecode(file(var.global_config_file))
  }
}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "tf-nx-prod-remote-state"
    key    = "global/prod/talkclub/network/terraform.tfstate"
    region = "ap-northeast-2"
    profile = var.aws_profile
  }
}

module "security_group" {
  source = "../../../../modules/network/security-group"

  for_each = {for application in local.config.local.applications: application.alb_name_suffix => application.service_port }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  target_service_name = "${each.key}-app"
  vpc_id              = data.terraform_remote_state.network.outputs.vpc_id

  ingress_rules = [
    {
      id          = "0"
      protocol    = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH connect"
    },
    {
      id          = "1"
      protocol    = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_blocks = ["0.0.0.0/0"]
      description = "Common"
    },
    {
      id          = "2"
      protocol    = "tcp"
      from_port   = each.value
      to_port     = each.value  
      cidr_blocks = ["0.0.0.0/0"]
      description = "Common"
    },
  ]
  egress_rules = [
    {
      id          = "0"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow to communicate to the Internet."
    }
  ]
}

module "alb_listener_rule" {
  source = "../../../../modules/network/alb-listener-rule"  

  for_each = {for application in local.config.local.applications: application.alb_name_suffix => application }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  listener_arn = data.terraform_remote_state.network.outputs.alb_listener_arns["${each.value.alb_name_suffix}-default_listener"]
  priority = 1
  conditions = [
    {
      type = "PATH",
      values = ["/*"]
    }
  ]
  action_type = "FORWARD"
  action_parameters = {target_group_arn = module.alb_target_group_instance[each.key].arn }
}

module "alb_target_group_instance" {
  source = "../../../../modules/network/alb-target-group-instance"  
  for_each = { for application in local.config.local.applications: application.alb_name_suffix => application }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = "${local.config.global.project_name}-${each.key}"

  vpc_id = data.terraform_remote_state.network.outputs.vpc_id
  instance_ids  = [for ec2 in each.value.ec2s : module.ec2_instance["${each.value.alb_name_suffix}-${ec2.service_name}"].id]
  port  = each.value.service_port

  health_check = {
    enabled             = true
    interval            = 30
    path                = "/api/v1/health"
    healthy_threshold   = 5
    unhealthy_threshold = 2
    timeout             = 5
    protocol            = "HTTP"
  }
}

module "ec2_instance" {
  source = "../../../../modules/service/ec2"

  for_each = {
    for alb_ec2 in flatten([for application in local.config.local.applications : [
      for ec2 in application.ec2s : {
        alb_name_suffix = application.alb_name_suffix
        service_port = application.service_port
        ec2 = ec2
      }]
    ]) : "${alb_ec2.alb_name_suffix}-${alb_ec2.ec2.service_name}" => alb_ec2
  }

  stage        = local.config.global.stage
  created_by   = local.config.global.created_by
  project_name = local.config.global.project_name

  service_name                = each.value.ec2.service_name
  ami_name                    = each.value.ec2.ami_name
  owners                      = ["643554540047"]
  instance_type               =  each.value.ec2.instance_type
  associate_public_ip_address =  each.value.ec2.associate_public_ip_address
  key_name                    = "prod-noox-web"
  subnet_id                   = [for s in data.terraform_remote_state.network.outputs.subnet_groups[each.value.ec2.subnet_type].subnets : s if s.cidr_block == each.value.ec2.subnet_cidr][0].id
  availability_zone           = [for s in data.terraform_remote_state.network.outputs.subnet_groups[each.value.ec2.subnet_type].subnets : s if s.cidr_block == each.value.ec2.subnet_cidr][0].availability_zone
  ebs_block_device            = { ebs_block_device = each.value.ec2.ebs_block_device }
  security_groups = [
    module.security_group[each.value.alb_name_suffix].id
  ]
}
