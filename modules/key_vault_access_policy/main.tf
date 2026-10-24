resource "azurerm_key_vault_access_policy" "policy" {
  for_each = var.access_policies

  key_vault_id = each.value.key_vault_id
  tenant_id    = each.value.tenant_id
  object_id    = each.value.object_id

  key_permissions = lookup(each.value, "key_permissions", [
    "Get", "List", "Create", "Delete", "Update"
  ])

  secret_permissions = lookup(each.value, "secret_permissions", [
    "Get", "List", "Set", "Delete", "Purge", "Recover"
  ])
}
