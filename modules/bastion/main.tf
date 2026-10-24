resource "azurerm_bastion_host" "bastion" {
  for_each = var.bastions

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = lookup(each.value, "sku", "Basic")

  ip_configuration {
    name                 = "configuration"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = each.value.public_ip_id
  }

  tags = lookup(each.value, "tags", null)
}
