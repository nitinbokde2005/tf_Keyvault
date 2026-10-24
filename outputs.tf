output "resource_groups" {
  description = "The created resource groups"
  value       = module.resource_group.resource_groups
}

output "virtual_networks" {
  description = "The created virtual networks"
  value       = module.virtual_network.virtual_networks
}

output "subnets" {
  description = "The created subnets"
  value       = module.subnet.subnets
}

output "nsgs" {
  description = "The created network security groups"
  value       = module.network_security_group.nsgs
}

output "nsg_associations" {
  description = "The created NSG associations"
  value       = module.nsg_association.nsg_associations
}

output "public_ips" {
  description = "The created public IPs"
  value       = module.public_ip.public_ips
}

output "nics" {
  description = "The created network interfaces"
  value       = module.network_interface.nics
}

output "load_balancers" {
  description = "The created load balancers"
  value       = module.load_balancer.load_balancers
}

output "key_vaults" {
  description = "The created key vaults"
  value       = module.key_vault.key_vaults
}

output "key_vault_secrets" {
  description = "The created key vault secrets"
  value       = module.key_vault_secret.key_vault_secrets
  sensitive   = true
}

output "bastions" {
  description = "The created bastion hosts"
  value       = module.bastion.bastions
}

output "virtual_machines" {
  description = "The created virtual machines"
  value       = module.virtual_machine.virtual_machines
  sensitive   = true
}
