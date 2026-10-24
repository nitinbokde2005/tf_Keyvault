resource "azurerm_linux_virtual_machine" "vm" {
  #tfsec:ignore:azure-compute-disable-password-authentication
  #checkov:skip=CKV_AZURE_1:Password authentication is required for Key Vault password retrieval demo
  #checkov:skip=CKV_AZURE_178:Password authentication is part of Key Vault credentials assignment
  #checkov:skip=CKV_AZURE_149:Password authentication is intentionally tested via Key Vault secret
  for_each = var.virtual_machines

  name                            = each.value.name
  resource_group_name             = each.value.resource_group_name
  location                        = each.value.location
  size                            = lookup(each.value, "size", "Standard_B1s")
  admin_username                  = each.value.admin_username
  admin_password                  = each.value.admin_password
  disable_password_authentication = false
  allow_extension_operations      = false
  network_interface_ids           = [each.value.network_interface_id]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

  tags = lookup(each.value, "tags", null)
}
