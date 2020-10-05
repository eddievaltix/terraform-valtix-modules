variable "mgmt_vpc_cidr" {
  description = "CIDR block of the mgmt VPC for Valtix Gateway"
}

variable "datapath_vpc_cidr" {
  description = "CIDR block of the datapath VPC for Valtix Gateway"
}

variable "region" {
  description = "region where Google Cloujd VPC subnet gets deployed"
}
