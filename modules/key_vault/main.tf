resource "azurerm_key_vault" "kv" {
  #checkov:skip=CKV_AZURE_189:Public network access is enabled for deployment without private endpoint
  #checkov:skip=CKV2_AZURE_32:Private endpoint is not configured in this assignment
  for_each = var.key_vaults

  name                       = each.value.name
  location                   = each.value.location
  resource_group_name        = each.value.resource_group_name
  tenant_id                  = each.value.tenant_id
  sku_name                   = lookup(each.value, "sku_name", "standard")
  soft_delete_retention_days = 7
  purge_protection_enabled   = lookup(each.value, "purge_protection_enabled", false)

  public_network_access_enabled = lookup(each.value, "public_network_access_enabled", true)

  network_acls {
    bypass         = "AzureServices"
    default_action = lookup(each.value, "network_acls_default_action", "Allow")
  }

  tags = lookup(each.value, "tags", null)
}

