output "access_policies" {
  description = "The created Key Vault access policies"
  value       = azurerm_key_vault_access_policy.policy
}
