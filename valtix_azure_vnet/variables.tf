variable "vnet_cidr" {
  description = "CIDR of the Virtual Network created for Valtix Gateway"
  default     = "10.0.0.0/16"
}

variable "location" {
  description = "Azure location where the resource group and all objects in this Terraform template will be created"
  default     = "eastus2"
}

variable "valtix_gateway_name" {
  description = "Name of the Valtix Gateway used to name other resources in this vnet"
  default     = "valtix"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}
