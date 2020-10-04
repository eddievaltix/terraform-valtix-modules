output "vnet_id" {
  value = azurerm_virtual_network.gw_vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.gw_vnet.name
}

output "vnet_location" {
  value = azurerm_virtual_network.gw_vnet.location
}

output "vnet_resource_group" {
  value = azurerm_virtual_network.gw_vnet.resource_group_name
}

output "nsg_mgmt_id" {
  value = azurerm_network_security_group.gw_mgmt_nsg.id
}

output "nsg_datapath_id" {
  value = azurerm_network_security_group.gw_dp_nsg.id
}
