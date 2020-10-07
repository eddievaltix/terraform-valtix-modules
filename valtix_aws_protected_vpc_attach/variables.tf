variable "valtix_cloud_account_name" {
  description = "Name of Valtix Cloud Account"
}

variable "protected_vpc_name" {
  description = "vpc name of the VPC to protect"
}

variable "protected_vpc_id" {
  description = "vpc ID of the VPC to protect"
}

variable "transit_gateway_id" {
  description = "transit gateway id"
}

variable "protected_vpc_subnet_ids" {
  description = "these are the protected subnet IDs that need to be associated with Transit Gateway attachment"
}