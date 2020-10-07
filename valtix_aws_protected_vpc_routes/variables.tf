variable "transit_gateway_id" {
  description = "transit gateway id"
}

variable "valtix_gateway_vpc_name" {
  description = "Name of the Services VPC where Valtix Gateway is deployed"
}

variable "is_egress" {
  description = "Boolean to determine if this is being used for a Valtix Egress Gateway"
  default = "false"
}

variable "protected_vpc_attachment_id" {
  description = "protected VPC Transit Gateway attachment ID. This is an output from valtix_aws_protected_vpc module"
}

variable "protected_vpc_attachment_route_table_id" {
  description = "this is the protected VPC attachment route table ID.  This is an output from valtix_aws_protected_vpc module"
}

variable "protected_vpc_subnet_ids" {
  description = "this is the list of protected vpc subnets that are tagged for routes to be added to Valtix"
}