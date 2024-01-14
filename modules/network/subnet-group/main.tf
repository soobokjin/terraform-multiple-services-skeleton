locals {
  availability_zones = distinct(
    values(aws_subnet.this)[*].availability_zone
  )
  availability_zone_ids = distinct(
    values(aws_subnet.this)[*].availability_zone_id
  )
  subnets = [
    for subnet in aws_subnet.this : {
      id      = subnet.id
      arn     = subnet.arn
      name    = subnet.tags["Name"]
      ip_type = subnet.tags["IpType"]

      availability_zone    = subnet.availability_zone
      availability_zone_id = subnet.availability_zone_id

      cidr_block = subnet.cidr_block
    }
  ]
}

resource "aws_subnet" "this" {
  vpc_id                  = var.vpc_id
  map_public_ip_on_launch = var.map_public_ip_on_launch


  for_each = var.subnets

  cidr_block        = each.value.cidr_block
  availability_zone = each.value.availability_zone

  tags = {
    Name      = "${var.stage}-${var.project_name}-${each.value.ip_type}-subnet-${substr(each.value.availability_zone, -1, 0)}"
    Stage     = var.stage
    CreatedBy = var.created_by
    IpType    = "${each.value.ip_type}"
  }
}