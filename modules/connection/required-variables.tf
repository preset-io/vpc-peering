variable "peer_vpc_id" {
  description = "The ID of the VPC with which you are creating the VPC Peering Connection."
  type        = string
}

variable "vpc_id" {
  description = "The ID of the requester VPC."
  type        = string
}
