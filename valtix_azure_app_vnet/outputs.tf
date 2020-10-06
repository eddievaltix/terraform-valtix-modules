output "vnet_id" {
  value       = azurerm_virtual_network.it.id
  description = "This is the Azure VNET ID of the VNET resource created"
}

output "vnet_name" {
  value       = azurerm_virtual_network.it.name
  description = "This is the Azure VNET Name of the VNET resource created"
}

output "vnet_resource_group" {
  value = azurerm_virtual_network.it.resource_group_name
  description = "This is the Azure Resource Group where the VNET resource is created"
}