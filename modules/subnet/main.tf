resource "azurerm_subnet" "subnet" {
  #checkov:skip=CKV2_AZURE_31:NSG association is managed separately in the nsg_association module
  for_each = var.subnets

  name                 = each.value.name
  resource_group_name  = each.value.resource_group_name
  virtual_network_name = each.value.virtual_network_name
  address_prefixes     = each.value.address_prefixes
}
