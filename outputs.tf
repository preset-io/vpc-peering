output "output" {
  value = {
    "requester" = module.requester_peering_connection
    "accepter"  = module.accepter_peer
  }
}

