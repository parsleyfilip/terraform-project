output "storage_account_url" {
  value       = azurerm_storage_account.sa.primary_blob_endpoint
  description = "De URL van je beveiligde storage account: "
}

output "hub_vnet_id" {
  value = module.hub.vnet_id
}

output "spoke_vnet_id" {
  value = module.spoke.vnet_id
}
