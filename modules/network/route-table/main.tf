resource "aws_route_table" "this" {
  vpc_id = var.vpc_id

  tags = {
    Name      = "${var.stage}-${var.project_name}-${var.ip_type}-route"
    Stage     = var.stage
    CreatedBy = var.created_by
  }
}

resource "aws_route" "ipv4" {
  for_each = {
    for route in var.ipv4_routes :
    route.cidr_block => route
  }

  route_table_id         = aws_route_table.this.id
  destination_cidr_block = each.key

  carrier_gateway_id        = try(each.value.carrier_gateway_id, null)
  egress_only_gateway_id    = try(each.value.egress_only_gateway_id, null)
  gateway_id                = try(each.value.gateway_id, null)
  instance_id               = try(each.value.instance_id, null)
  local_gateway_id          = try(each.value.local_gateway_id, null)
  nat_gateway_id            = try(each.value.nat_gateway_id, null)
  network_interface_id      = try(each.value.network_interface_id, null)
  transit_gateway_id        = try(each.value.transit_gateway_id, null)
  vpc_endpoint_id           = try(each.value.vpc_endpoint_id, null)
  vpc_peering_connection_id = try(each.value.vpc_peering_connection_id, null)
}


resource "aws_route_table_association" "subnets" {
  count = length(var.subnets)

  route_table_id = aws_route_table.this.id
  subnet_id      = var.subnets[count.index].id
}

