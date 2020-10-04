resource "azurerm_virtual_network" gw_vnet {
  name                = "${var.valtix_gateway_name}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]

  subnet {
    name              = "mgmt"
    address_prefix    = cidrsubnet(var.vnet_cidr,8,0)
  }
  subnet {
    name              = "datapath"
    address_prefix    = cidrsubnet(var.vnet_cidr,8,1)
  }
}