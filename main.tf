terraform {
  # This is used to store the State files to Azure Storage Account. 
  # If using different Storage Accounts for different envs these could be moved to tfvars file too. 
  backend "azurerm" {
      resource_group_name  = "SA_RG"                # RG of the Storage Acc.
      storage_account_name = "SA_NAME"              # Storage Account's name.
      container_name       = "tfstate"              # Name of the SA Container.
      key                  = "NSG/nsg.tfstate"      # Name/Path of the state file.
  }
}

provider "azurerm" {
  features {}
}

locals {
  nsg_rules = var.nsg_rules
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
  destination_address_prefix  = lookup(each.value, "destination_address_prefix", null) #(Optional) CIDR or destination IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. Besides, it also supports all available Service Tags
  destination_address_prefixes  = lookup(each.value, "destination_address_prefixes", null) #(Optional) List of destination address prefixes. Tags may not be used. This is required if destination_address_prefix is not specified.
  source_address_prefix   = lookup(each.value, "source_address_prefix", null) #(Optional) CIDR or source IP range or * to match any IP. Tags such as VirtualNetwork, AzureLoadBalancer and Internet can also be used. This is required if source_address_prefixes is not specified. 
  source_address_prefixes   = lookup(each.value, "source_address_prefixes", null) #(Optional) List of source address prefixes. Tags may not be used. This is required if source_address_prefix is not specified.
  source_application_security_group_ids = lookup(each.value, "source_application_security_group_ids", null) #(Optional) A List of source Application Security Group IDs
  destination_application_security_group_ids = lookup(each.value, "destination_application_security_group_ids", null) #(Optional) A List of destination Application Security Group IDs
  resource_group_name = var.resource_group_name
  network_security_group_name = var.nsg_name
}
