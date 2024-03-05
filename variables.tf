variable "nsg_rules" {
  description = "The NSG rules that will apply to the Subnets/NICs"
  type        = map(object({
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    source_port_range                          = string
    destination_port_range                     = string
    source_address_prefix                      = string     # list(string) ?
    destination_address_prefix                 = string     # list(string) ?
    source_application_security_group_ids      = list(string)
    destination_application_security_group_ids = list(string)
  }))
}

variable "nsg_name" {
  description = "The name of the NSG to deploy the rules to"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group containing the NSG"
  type        = string
}

variable "nsg_location" {
  description = "Location in which the NSG / RG is present"
  type        = string
}