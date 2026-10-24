# ==========================================
# DEV Environment Configuration
# ==========================================

# 1. Resource Groups
resource_groups = {
  "dev_rg" = {
    name     = "rg-dev-b18"
    location = "East US"
    tags = {
      Environment = "dev"
      ManagedBy   = "Terraform"
    }
  }
}

# 2. Virtual Networks
virtual_networks = {
  "dev_vnet" = {
    name                = "vnet-dev-b18"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    address_space       = ["10.0.0.0/16"]
    tags = {
      Environment = "dev"
    }
  }
}

# 3. Subnets
# Note: Azure requires Azure Bastion subnet to be named exactly 'AzureBastionSubnet' with prefix >= /26
subnets = {
  "bastion_subnet" = {
    name                 = "AzureBastionSubnet"
    resource_group_name  = "rg-dev-b18"
    virtual_network_name = "vnet-dev-b18"
    address_prefixes     = ["10.0.1.0/26"]
  }
  "vm_subnet" = {
    name                 = "snet-dev-workload"
    resource_group_name  = "rg-dev-b18"
    virtual_network_name = "vnet-dev-b18"
    address_prefixes     = ["10.0.2.0/24"]
  }
}

# 4. Network Security Groups (NSG)
nsgs = {
  "dev_nsg" = {
    name                = "nsg-dev-b18"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    security_rules = [
      {
        name                       = "Allow-SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
      }
    ]
    tags = {
      Environment = "dev"
    }
  }
}

# 5. NSG Subnet Association
nsg_associations = {
  "dev_vm_subnet_nsg" = {
    subnet_key = "vm_subnet"
    nsg_key    = "dev_nsg"
  }
}

# 6. Public IPs (Standard SKU & Static for Bastion & LB)
public_ips = {
  "bastion_pip" = {
    name                = "pip-dev-bastion"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    allocation_method   = "Static"
    sku                 = "Standard"
    tags = {
      Environment = "dev"
    }
  }
  "lb_pip" = {
    name                = "pip-dev-lb"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    allocation_method   = "Static"
    sku                 = "Standard"
    tags = {
      Environment = "dev"
    }
  }
}

# 7. Network Interfaces (NIC)
nics = {
  "vm_nic" = {
    name                          = "nic-dev-vm"
    location                      = "East US"
    resource_group_name           = "rg-dev-b18"
    subnet_key                    = "vm_subnet"
    private_ip_address_allocation = "Dynamic"
    tags = {
      Environment = "dev"
    }
  }
}

# 8. Azure Load Balancer
load_balancers = {
  "dev_lb" = {
    name                = "lb-dev-b18"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    sku                 = "Standard"
    frontend_ip_name    = "lb-frontend"
    public_ip_key       = "lb_pip"
    backend_pool_name   = "lb-backend-pool"
    tags = {
      Environment = "dev"
    }
  }
}

# 9. Key Vaults
# Note: Key Vault name must be globally unique across all of Azure (3-24 alphanumeric characters)
key_vaults = {
  "dev_kv" = {
    name                     = "kv-dev-b18-0914"
    location                 = "East US"
    resource_group_name      = "rg-dev-b18"
    sku_name                 = "standard"
    purge_protection_enabled = false
    tags = {
      Environment = "dev"
    }
  }
}

# 10. Key Vault Secrets (VM credentials stored in Key Vault instead of VM config)
key_vault_secrets = {
  "vm_username" = {
    name          = "vm-admin-username"
    value         = "azuredevuser"
    key_vault_key = "dev_kv"
  }
  "vm_password" = {
    name          = "vm-admin-password"
    key_vault_key = "dev_kv"
  }
}

# 11. Azure Bastion
bastions = {
  "dev_bastion" = {
    name                = "bas-dev-b18"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    subnet_key          = "bastion_subnet"
    public_ip_key       = "bastion_pip"
    sku                 = "Basic"
    tags = {
      Environment = "dev"
    }
  }
}

# 12. Virtual Machines (credentials removed from here!)
virtual_machines = {
  "dev_vm" = {
    name                = "vm-dev-b18"
    location            = "East US"
    resource_group_name = "rg-dev-b18"
    nic_key             = "vm_nic"
    size                = "Standard_D2as_v4"
    tags = {
      Environment = "dev"
    }
  }
}
