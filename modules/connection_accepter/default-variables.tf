variable "auto_accept" {
  description = "Whether or not to accept the peering request. Defaults to false."
  type        = bool
  default     = false
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
