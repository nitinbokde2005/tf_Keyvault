output "nsg_associations" {
  description = "The created subnet to NSG associations"
  value       = azurerm_subnet_network_security_group_association.nsg_assoc
}
