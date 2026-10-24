variable "resource_groups" {
  description = "Map of resource groups to create"
  type        = map(any)
}

variable "virtual_networks" {
  description = "Map of virtual networks to create"
  type        = map(any)
}

variable "subnets" {
  description = "Map of subnets to create"
  type        = map(any)
}

variable "public_ips" {
  description = "Map of public IPs to create"
  type        = map(any)
}

variable "nics" {
  description = "Map of network interfaces to create"
  type        = map(any)
}

variable "load_balancers" {
  description = "Map of load balancers to create"
  type        = map(any)
}

variable "key_vaults" {
  description = "Map of key vaults to create"
  type        = map(any)
}

variable "key_vault_secrets" {
  description = "Map of key vault secrets to create"
  type        = map(any)
}

variable "vm_password" {
  description = "Admin password for the VM (stored securely in Key Vault)"
  type        = string
  sensitive   = true
}


variable "nsgs" {
  description = "Map of network security groups to create"
  type        = map(any)
}

variable "nsg_associations" {
  description = "Map of subnet NSG associations to create"
  type        = map(any)
}

variable "bastions" {
  description = "Map of Azure Bastion hosts to create"
  type        = map(any)
}

variable "virtual_machines" {
  description = "Map of virtual machines to create"
  type        = map(any)
}
