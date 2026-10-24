# 1. Resource Group Module
module "resource_group" {
  source          = "./modules/resource_group"
  resource_groups = var.resource_groups
}

# 2. Virtual Network Module (depends on resource_group)
module "virtual_network" {
  source           = "./modules/virtual_network"
  virtual_networks = var.virtual_networks

  depends_on = [module.resource_group]
}

# 3. Subnet Module (depends on virtual_network)
module "subnet" {
  source  = "./modules/subnet"
  subnets = var.subnets

  depends_on = [module.virtual_network]
}

# 4. Network Security Group Module (depends on resource_group)
module "network_security_group" {
  source = "./modules/network_security_group"
  nsgs   = var.nsgs

  depends_on = [module.resource_group]
}

# 5. NSG Subnet Association Module (depends on subnet & nsg)
module "nsg_association" {
  source = "./modules/nsg_association"
  nsg_associations = {
    for k, v in var.nsg_associations : k => merge(v, {
      subnet_id                 = module.subnet.subnets[v.subnet_key].id
      network_security_group_id = module.network_security_group.nsgs[v.nsg_key].id
    })
  }

  depends_on = [module.subnet, module.network_security_group]
}

# 6. Public IP Module (depends on resource_group)
module "public_ip" {
  source     = "./modules/public_ip"
  public_ips = var.public_ips

  depends_on = [module.resource_group]
}

# 7. Network Interface Module (depends on subnet)
module "network_interface" {
  source = "./modules/network_interface"
  nics = {
    for k, v in var.nics : k => merge(v, {
      subnet_id = module.subnet.subnets[v.subnet_key].id
    })
  }

  depends_on = [module.subnet]
}

# 8. Load Balancer Module (depends on resource_group, public_ip)
module "load_balancer" {
  source = "./modules/load_balancer"
  load_balancers = {
    for k, v in var.load_balancers : k => merge(v, {
      public_ip_address_id = lookup(v, "public_ip_key", null) != null ? module.public_ip.public_ips[v.public_ip_key].id : null
    })
  }

  depends_on = [module.resource_group, module.public_ip]
}

# 9. Key Vault Module (depends on resource_group)
module "key_vault" {
  source = "./modules/key_vault"
  key_vaults = {
    for k, v in var.key_vaults : k => merge(v, {
      tenant_id = data.azurerm_client_config.current.tenant_id
    })
  }

  depends_on = [module.resource_group]
}

# 10. Key Vault Access Policy Module (grants access to current user/spn)
module "key_vault_access_policy" {
  source = "./modules/key_vault_access_policy"
  access_policies = {
    for k, v in var.key_vaults : k => {
      key_vault_id = module.key_vault.key_vaults[k].id
      tenant_id    = data.azurerm_client_config.current.tenant_id
      object_id    = data.azurerm_client_config.current.object_id
    }
  }

  depends_on = [module.key_vault]
}

# 11. Key Vault Secret Module (stores VM credentials in Key Vault)
module "key_vault_secret" {
  source = "./modules/key_vault_secret"
  key_vault_secrets = {
    for k, v in var.key_vault_secrets : k => merge(v, {
      key_vault_id = module.key_vault.key_vaults[v.key_vault_key].id
      value        = k == "vm_password" ? var.vm_password : lookup(v, "value", null)
    })
  }

  depends_on = [module.key_vault, module.key_vault_access_policy]
}

# -------------------------------------------------------------
# Data Blocks: Retrieve credentials from Key Vault
# -------------------------------------------------------------
data "azurerm_key_vault_secret" "vm_username" {
  name         = var.key_vault_secrets["vm_username"].name
  key_vault_id = module.key_vault.key_vaults["dev_kv"].id

  depends_on = [module.key_vault_secret]
}

data "azurerm_key_vault_secret" "vm_password" {
  name         = var.key_vault_secrets["vm_password"].name
  key_vault_id = module.key_vault.key_vaults["dev_kv"].id

  depends_on = [module.key_vault_secret]
}

# 12. Azure Bastion Module (depends on subnet, public_ip)
module "bastion" {
  source = "./modules/bastion"
  bastions = {
    for k, v in var.bastions : k => merge(v, {
      subnet_id    = module.subnet.subnets[v.subnet_key].id
      public_ip_id = module.public_ip.public_ips[v.public_ip_key].id
    })
  }

  depends_on = [module.subnet, module.public_ip]
}

# 13. Virtual Machine Module (credentials fetched from Key Vault via data block)
module "virtual_machine" {
  source = "./modules/virtual_machine"
  virtual_machines = {
    for k, v in var.virtual_machines : k => merge(v, {
      network_interface_id = module.network_interface.nics[v.nic_key].id
      admin_username       = data.azurerm_key_vault_secret.vm_username.value
      admin_password       = data.azurerm_key_vault_secret.vm_password.value
    })
  }

  depends_on = [module.network_interface, module.key_vault_secret]
}
