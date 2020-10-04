output "vnet_id" {
  value = azurerm_virtual_network.gw_vnet.id
}

output "vnet_resource_group" {
  value = azurerm_virtual_network.gw_vnet.resource_group_name
}