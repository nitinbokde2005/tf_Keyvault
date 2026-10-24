resource "azurerm_key_vault_secret" "secret" {
  for_each = var.key_vault_secrets

  name            = each.value.name
  value           = each.value.value
  key_vault_id    = each.value.key_vault_id
  content_type    = lookup(each.value, "content_type", "password")
  expiration_date = lookup(each.value, "expiration_date", "2027-12-31T00:00:00Z")
}

