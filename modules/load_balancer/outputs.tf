output "load_balancers" {
  description = "The created load balancers"
  value       = azurerm_lb.lb
}

output "backend_address_pools" {
  description = "The created backend address pools"
  value       = azurerm_lb_backend_address_pool.pool
}
