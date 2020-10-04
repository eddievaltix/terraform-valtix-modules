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

resource "azurerm_network_security_group" gw_mgmt_nsg {
  name                = "valtix-mgmt-sg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_security_group" gw_dp_nsg {
  name                = "valtix-datapath-sg"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "allow-all"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}