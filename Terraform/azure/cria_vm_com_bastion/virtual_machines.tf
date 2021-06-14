# Create virtual machine Linux01
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "LINUX01VM"
    location              = "eastus2"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic.id]
    vm_size               = "Standard_D2_v3"

    storage_os_disk {
        name              = "LINUX01OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "SRV-LINUX01"
        admin_username = "igti"
        admin_password = "Azure@202020"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "empresa"
    }
}

# Create virtual machine Linux02
resource "azurerm_virtual_machine" "myterraformvm2" {
    name                  = "LINUX02VM"
    location              = "eastus2"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic2.id]
    vm_size               = "Standard_D2_v3"

    storage_os_disk {
        name              = "LINUX02OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "SRV-LINUX02"
        admin_username = "igti"
        admin_password = "Azure@202020"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "empresa"
    }
}

# Create virtual machine Linux03
resource "azurerm_virtual_machine" "myterraformvm3" {
    name                  = "LINUX03VM"
    location              = "eastus2"
    resource_group_name   = azurerm_resource_group.myterraformgroup.name
    network_interface_ids = [azurerm_network_interface.myterraformnic3.id]
    vm_size               = "Standard_D2_v3"

    storage_os_disk {
        name              = "LINUX03OsDisk"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
    }

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "18.04-LTS"
        version   = "latest"
    }

    os_profile {
        computer_name  = "SRV-LINUX03"
        admin_username = "igti"
        admin_password = "Azure@202020"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    boot_diagnostics {
        enabled = "true"
        storage_uri = azurerm_storage_account.mystorageaccount.primary_blob_endpoint
    }

    tags = {
        environment = "empresa"
    }
}