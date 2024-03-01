terraform {
  # This is used to store the State files to Azure Storage Account. 
  # If using different Storage Accounts for different envs these could be moved to tfvars file too. 
  backend "azurerm" {
      resource_group_name  = "cloud-shell-storage-centralindia" # RG of the Storage Acc.
      storage_account_name = "csg10032000fd9ed4d1"              # Storage Account's name.
      container_name       = "tfstate"                          # Name of the SA Container.
      key                  = "NSG/nsg.tfstate"                  # Name/Path of the state file.
  }
}

provider "azurerm" {
  features {}
}

locals {
  nsg_rules = jsondecode(file(var.nsg_rules))
}

resource "azurerm_network_security_rule" "nsg_rule" {
  for_each            = local.nsg_rules
  name                = each.key
  priority            = each.value.priority
  direction           = each.value.direction
  access              = each.value.access
  protocol            = each.value.protocol
  #description        = 
  source_port_range   = each.value.source_port_range
  destination_port_range  = each.value.destination_port_range
  source_address_prefix   = lookup(each.value, "source_address_prefix", null)
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", null)
  source_application_security_group_ids = lookup(each.value, "source_application_security_group_ids", null)
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null)
  resource_group_name = var.resource_group_name
  network_security_group_name = var.nsg_name
}
