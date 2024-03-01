terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  backend "azurerm" {
      resource_group_name  = "gc-lab-rg-abhishek"
      storage_account_name = "gcstgadrgtest"
      container_name       = "tfstate"
      key                  = "PublicIP"
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
  source_port_range   = each.value.source_port_range
  destination_port_range  = each.value.destination_port_range
  source_address_prefix   = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name = var.resource_group_name
  network_security_group_name = var.nsg_name
  #description ??
}
