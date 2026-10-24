resource "azurerm_network_interface" "nic" {
  for_each = var.nics

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = lookup(each.value, "private_ip_address_allocation", "Dynamic")
    public_ip_address_id          = lookup(each.value, "public_ip_address_id", null)
  }

  tags = lookup(each.value, "tags", null)
}
