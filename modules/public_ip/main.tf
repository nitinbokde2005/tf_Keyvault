resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = lookup(each.value, "allocation_method", "Static")
  sku                 = lookup(each.value, "sku", "Standard")
  tags                = lookup(each.value, "tags", null)
}
