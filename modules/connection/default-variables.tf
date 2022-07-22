variable "auto_accept" {
  description = "Accept the peering (both VPCs need to be in the same AWS account)."
  type        = bool
  default     = false
}

variable "peer_owner_id" {
  description = "The AWS account ID of the owner of the peer VPC. Defaults to the account ID the AWS provider is currently connected to."
  type        = string
  default     = null
}

variable "peer_region" {
  description = "The region of the accepter VPC of the VPC Peering Connection. auto_accept must be false, and use the aws_vpc_peering_connection_accepter to manage the accepter side."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}

variable "accepter_requester_default_options" {
  description = "default options for accepter requester options to be merged with accepter or requester"
  type = object(
  {
    allow_classic_link_to_remote_vpc = bool
    allow_remote_vpc_dns_resolution  = bool
    allow_vpc_to_remote_classic_link = bool
  }
  )
  default = {
    allow_classic_link_to_remote_vpc = false # Allow a local linked EC2-Classic instance to communicate with instances in a peer VPC. This enables an outbound communication from the local ClassicLink connection to the remote VPC.
    allow_remote_vpc_dns_resolution  = false # Allow a local VPC to resolve public DNS hostnames to private IP addresses when queried from instances in the peer VPC. This is not supported for inter-region VPC peering.
    allow_vpc_to_remote_classic_link = false # Allow a local VPC to communicate with a linked EC2-Classic instance in a peer VPC. This enables an outbound communication from the local VPC to the remote ClassicLink connection.
  }
}

variable "accepter" {
  description = "A list of one configuration block that allows for VPC Peering Connection options to be set for the VPC that accepts the peering connection."
  type = list(map(bool))
  default = []
}

variable "requester" {
  description = "A list of one  configuration block that allows for VPC Peering Connection options to be set for the VPC that requests the peering connection"
  type = list(map(bool))
  default = []
}

variable "timeouts" {
  description = "A list of timeouts configurations"
  type = set(object(
  {
    create = string
    delete = string
    update = string
  }
  ))
  default = []
}
