variable "protected_vpc_name" {
  description = "Name of the VPC to protect"
}

variable "transit_gateway_id" {
  description = "transit gateway ID"
}

variable "valtix_gateway_vpc_name" {
  description = "Name of the Services VPC where Valtix Gateway is deployed"
}

variable "is_egress" {
  description = "Boolean to determine if this is being used for a Valtix Egress Gateway"
  default = "false"
}
