resource "azurerm_lb" "lb" {
  for_each = var.load_balancers

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = lookup(each.value, "sku", "Standard")

  frontend_ip_configuration {
    name                 = lookup(each.value, "frontend_ip_name", "LoadBalancerFrontEnd")
    public_ip_address_id = lookup(each.value, "public_ip_address_id", null)
  }

  tags = lookup(each.value, "tags", null)
}

resource "azurerm_lb_backend_address_pool" "pool" {
  for_each = var.load_balancers

  loadbalancer_id = azurerm_lb.lb[each.key].id
  name            = lookup(each.value, "backend_pool_name", "BackEndAddressPool")
}
