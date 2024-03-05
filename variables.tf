variable "nsg_rules" {
  description = "The NSG rules that will apply to the Subnets/NICs"
#  
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