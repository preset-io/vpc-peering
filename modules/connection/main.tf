locals {
  accepter = [
    for options in var.accepter:
      merge(var.accepter_requester_default_options, options)
  ]
  requester = [
    for options in var.requester:
      merge(var.accepter_requester_default_options, options)
  ]
}

resource "aws_vpc_peering_connection" "peering_connection" {
  auto_accept   = var.auto_accept
  peer_owner_id = var.peer_owner_id
  peer_region   = var.peer_region
  peer_vpc_id   = var.peer_vpc_id
  tags          = var.tags
  vpc_id        = var.vpc_id

  dynamic "accepter" {
    for_each = local.accepter
    content {
      allow_classic_link_to_remote_vpc = accepter.value["allow_classic_link_to_remote_vpc"]
      allow_remote_vpc_dns_resolution  = accepter.value["allow_remote_vpc_dns_resolution"]
      allow_vpc_to_remote_classic_link = accepter.value["allow_vpc_to_remote_classic_link"]
    }
  }

  dynamic "requester" {
    for_each = local.requester
    content {
      allow_classic_link_to_remote_vpc = requester.value["allow_classic_link_to_remote_vpc"]
      allow_remote_vpc_dns_resolution  = requester.value["allow_remote_vpc_dns_resolution"]
      allow_vpc_to_remote_classic_link = requester.value["allow_vpc_to_remote_classic_link"]
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }
}
