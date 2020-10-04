variable "vnet_cidr" {
  description = "CIDR of the Virtual Network created for Valtix Gateway"
  default     = "10.0.0.0/16"
}

variable "location" {
  description = "Azure location where the resource group and all objects in this Terraform template will be created"
  default     = "eastus2"
}

variable "vnet_name" {
  description = "Name of the virtual network to create"
  default     = "valtix-vnet"
}

variable "resource_group_name" {
  description = "Name of the resource group"
}
