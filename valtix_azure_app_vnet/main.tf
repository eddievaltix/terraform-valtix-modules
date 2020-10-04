resource "azurerm_virtual_network" it {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_cidr]

  subnet {
    name              = "subnet1"
    address_prefix    = cidrsubnet(var.vnet_cidr,8,0)
  }
}