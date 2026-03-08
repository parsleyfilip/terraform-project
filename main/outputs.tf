output "resource_group_id" {
  value       = azurerm_resource_group.rg.id
  description = "Het unieke ID van je Resource Group"
}

output "hub_vnet_name" {
  value = azurerm_virtual_network.hub.name
}

output "storage_account_primary_endpoint" {
  value       = azurerm_storage_account.sa.primary_blob_endpoint
  description = "De URL van je Blob Storage"
}

