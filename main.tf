provider "azurerm" {
  features {}
}

resource "azurerm_network_security_group" "nsg" {
  name                = var.nsg_name
  location            = azurerm_resource_group.nsg_rg.location
  resource_group_name = var.resource_group_name
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
  network_security_group_name = azurerm_network_security_group.nsg.name
}
