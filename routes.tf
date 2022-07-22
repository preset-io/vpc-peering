#
# Here, we need to add a route table entry to all route tables in both
# sides in order to route traffic back and forth properly
#
resource "aws_route" "accepter" {
  count    = local.accepter_route_table_cnt
  provider = aws.accepter

  route_table_id            = local.accepter_route_tables[count.index]
  destination_cidr_block    = local.requester_vpc_cidr
  vpc_peering_connection_id = module.requester_peering_connection.output.id
}

resource "aws_route" "requester" {
  // The requester side must be a static value as TF cannot determine resource counts dynamically
  // See issue: https://github.com/hashicorp/terraform/issues/21450
  count    = local.requester_route_table_cnt
  provider = aws.requester

  route_table_id            = local.requester_route_tables[count.index]
  destination_cidr_block    = local.accepter_vpc_cidr
  vpc_peering_connection_id = module.requester_peering_connection.output.id
}
