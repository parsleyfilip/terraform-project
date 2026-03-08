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

#
# Locatie is Switzerland omdat ik een studentenaccount heb en dit de enige locatie is die beschikbaar is voor mij!!
#

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

#
# Hub
#

resource "azurerm_virtual_network" "hub" {
  name                = "tf-project-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location // Verwijs de locatie naar de azurerm resource group
  resource_group_name = azurerm_resource_group.rg.name // Verwijs de resource group naam naar de azurerm resource group
}

resource "azurerm_subnet" "subnet_hub" {
  name                 = "tf-project-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.hub.name
  address_prefixes     = ["10.0.0.0/24"]
}

#
# Spoke 
#

resource "azurerm_virtual_network" "spoke" {
  name                = "tf-spoke-vnet"
  address_space       = ["10.1.0.0/16"] // Andere mask dan de hub
  location            = azurerm_resource_group.rg.location // Verwijs de locatie naar de azurerm resource group
  resource_group_name = azurerm_resource_group.rg.name // Verwijs de resource group naam naar de azurerm resource group
}

resource "azurerm_subnet" "subnet_spoke" {
  name                 = "tf-spoke-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.spoke.name
  address_prefixes     = ["10.1.0.0/24"] // Andere mask dan de hub

  service_endpoints    = ["Microsoft.Storage"]
}

#
# Brug van Hub naar Spoke
#

resource "azurerm_virtual_network_peering" "hub-to-spoke" {
  name                         = "hub-to-spoke"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.hub.name
  remote_virtual_network_id    = azurerm_virtual_network.spoke.id
  allow_virtual_network_access = true
}


#       
# Brug van Spoke naar Hub / De terugweg
#

resource "azurerm_virtual_network_peering" "spoke-to-hub" {
  name                         = "spoke-to-hub"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.spoke.name
  remote_virtual_network_id    = azurerm_virtual_network.hub.id
  allow_virtual_network_access = true
}

#
# Storage account
#

resource "azurerm_storage_account" "sa" {
  name                     = var.storage_name
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  network_rules {
    default_action = "Deny" # Spoke is gesloten voor het internet... 
    virtual_network_subnet_ids = [
      azurerm_subnet.subnet_spoke.id # Behalve de spoke zelf :)
    ]
  }
}