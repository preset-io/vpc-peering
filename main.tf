module "requester_peering_connection" {
  source = "./modules/connection"
  providers = {
    aws = aws.requester
  }

  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  auto_accept   = false
  peer_owner_id = data.aws_caller_identity.accepter.account_id
  peer_region   = var.accepter_region

  tags = merge(
    {
      "Name"        = "${local.accepter_vpc_name} <-> ${local.requester_vpc_name}"
      "Side"        = "Requester"
    },
    var.requester_tags,
  )
}

module "accepter_peer" {
  source = "./modules/connection_accepter"
  providers = {
    aws = aws.accepter
  }

  vpc_peering_connection_id = module.requester_peering_connection.output.id
  auto_accept               = true
  tags = merge(
    {
      "Name"        = "${local.accepter_vpc_name} <-> ${local.requester_vpc_name}"
      "Side"        = "Accepter"
    },
    var.accepter_tags,
  )
}
