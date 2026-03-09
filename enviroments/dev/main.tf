# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#
# De Hub
#
module "hub" {
  source              = "../../modules/vnet"
  vnet_name           = "tf-hub-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
  subnet_name         = "hub-subnet"
  subnet_prefixes     = ["10.0.0.0/24"]
}

#
# De Spoke
#
module "spoke" {
  source              = "../../modules/vnet"
  vnet_name           = "tf-spoke-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.1.0.0/16"]
  subnet_name         = "spoke-subnet"
  subnet_prefixes     = ["10.1.0.0/24"]
}

#
# Peering (De brug)
#
module "peering_hub_spoke" {
  source              = "../../modules/peering"
  resource_group_name = azurerm_resource_group.rg.name
  
  vnet_1_name = module.hub.vnet_name
  vnet_1_id   = module.hub.vnet_id
  
  vnet_2_name = module.spoke.vnet_name
  vnet_2_id   = module.spoke.vnet_id
}

#
# Storage account
#
resource "azurerm_storage_account" "sa" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Lowest tier want ik heb maar 100 euro credit #besparen

  network_rules {
    default_action             = "Deny" # Voor alles vanuit het internet op slot 
    virtual_network_subnet_ids = [module.spoke.subnet_id] # Maar de spoke mag er wel in :)
  }
}