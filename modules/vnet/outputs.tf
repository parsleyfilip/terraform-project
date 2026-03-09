output "vnet_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Het ID van het Virtual Network"
}

output "vnet_name" {
  value       = azurerm_virtual_network.vnet.name
  description = "De naam van het Virtual Network"
}

output "subnet_id" {
  value       = azurerm_subnet.subnet.id
  description = "Het ID van het subnet"
}
