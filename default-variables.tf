variable "requester_tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "accepter_tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "requester_route_table_ids" {
  description = "The route table IDs to be updated on the accepter side of the connection"
  type        = list(string)
  default     = []
}

variable "requester_route_table_cnt" {
  description = "In order to workaround TF's shortcoming of not being able to make resource count dynamic, this must be used in situations where we are creating route tables dynamically. (Typical EKS VPCs have 6 route tables)"
  type        = number
  default     = 0
}

variable "accepter_route_table_cnt" {
  description = "In order to workaround TF's shortcoming of not being able to make resource count dynamic, this must be used in situations where we are creating route tables dynamically. (Typical EKS VPCs have 6 route tables)"
  type        = number
  default     = 0
}

variable "accepter_route_table_ids" {
  description = "The route table IDs to be updated on the accepter side of the connection"
  type        = list(string)
  default     = []
}

variable "requester_vpc_name" {
  description = "requester VPC name"
  type        = string
  default     = "requester"
}

variable "accepter_vpc_name" {
  description = "accepter VPC name"
  type        = string
  default     = "accepter"
}
