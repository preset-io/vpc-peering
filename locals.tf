locals {
  accepter_route_tables    = distinct(var.accepter_route_table_cnt == 0 ? data.aws_route_tables.accepter.ids : var.accepter_route_table_ids)
  accepter_route_table_cnt = var.accepter_route_table_cnt == 0 ? length(data.aws_route_tables.accepter.ids) : var.accepter_route_table_cnt
  accepter_vpc_cidr        = data.aws_vpc.accepter.cidr_block
  accepter_vpc_name        = lookup(data.aws_vpc.accepter.tags, "Name", var.accepter_vpc_name)

  requester_route_tables    = distinct(var.requester_route_table_cnt == 0 ? data.aws_route_tables.requester.ids : var.requester_route_table_ids)
  requester_route_table_cnt = var.requester_route_table_cnt == 0 ? length(data.aws_route_tables.requester.ids) : var.requester_route_table_cnt
  requester_vpc_cidr        = data.aws_vpc.requester.cidr_block
  requester_vpc_name        = lookup(data.aws_vpc.requester.tags, "Name", var.requester_vpc_name)
}
