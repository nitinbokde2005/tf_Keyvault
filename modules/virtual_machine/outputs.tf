output "virtual_machines" {
  description = "The created virtual machines"
  value       = azurerm_linux_virtual_machine.vm
  sensitive   = true
}
