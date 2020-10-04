output "vnet_id" {
  value = azurerm_virtual_network.it.id
}

output "vnet_resource_group" {
  value = azurerm_virtual_network.it.resource_group_name
}