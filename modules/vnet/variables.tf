variable "resource_group_name" {
  type        = string
  description = "De naam van de RG waar dit netwerk in moet"
}

variable "location" {
  type        = string
  description = "De regio (bijv. europewest ofzo)"
}

variable "vnet_name" {
  type        = string
  description = "De naam van het Virtual Network"
}

variable "address_space" {
  type        = list(string)
  description = "De IP range van het VNet, bijv ['10.0.0.0/16']"
}

variable "subnet_name" {
  type        = string
  description = "De naam van het subnet binnen dit VNet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "De IP range van het subnet, bijv ['10.0.0.0/24']"
}