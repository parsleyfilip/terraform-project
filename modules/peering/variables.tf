variable "resource_group_name" { type = string }

#
# VNET 1
#

variable "vnet_1_name" {
    type = string
    description = "Naam van de eerste VNET"
}

variable "vnet_1_id" {
    type = string
    description = "ID van de eerste VNET"
}

#
# VNET 2
#

variable "vnet_2_name" {
    type = string
    description = "Naam van de tweede VNET"
}

variable "vnet_2_id" {
    type = string
    description = "ID van de derde VNET"
}