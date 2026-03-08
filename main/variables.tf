variable "location" {
  type    = string
  default = "switzerlandnorth"
}

variable "resource_group_name" {
  type    = string
  default = "tf-project-rg"
}

variable "storage_name" {
    type = string
    description = "Naam voor de storage account "
}