output "key_vault_secrets" {
  description = "The created Key Vault secrets"
  value       = azurerm_key_vault_secret.secret
  sensitive   = true
}
