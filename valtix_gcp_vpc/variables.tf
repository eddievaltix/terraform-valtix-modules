variable "mgmt_subnet_cidr" {
  description = "CIDR block of the mgmt VPC for Valtix Gateway"
}

variable "datapath_subnet_cidr" {
  description = "CIDR block of the datapath VPC for Valtix Gateway"
}

variable "egress_subnet_cidr" {
  description = "CIDR block of the egress VPC for Valtix Gateway"
}

variable "mgmt_vpc_name" {
  description = "name of management vpc"
  default     = "mgmt-vpc"
}

variable "datapath_vpc_name" {
  description = "name of datapath vpc"
   default    = "datapath-vpc"
}

variable "egress_vpc_name" {
  description = "name of egress vpc"
   default    = "egress-hub-vpc"
}

variable "mgmt_subnet_name" {
  description = "name of management subnet"
  default     = "mgmt-subnet"
}

variable "datapath_subnet_name" {
  description = "name of datapath subnet"
  default     = "datapath-subnet"
}

variable "egress_subnet_name" {
  description = "name of egress subnet"
  default     = "egress-hub-subnet"
}

variable "region" {
  description  = "region where Google Cloujd VPC subnet gets deployed"
}
