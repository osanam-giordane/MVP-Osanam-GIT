# Generate random text for a unique storage account name
resource "random_id" "randomId" {
    keepers = {
        # Generate a new ID only when a new resource group is defined
        resource_group = azurerm_resource_group.myterraformgroup.name
    }
    
    byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "mystorageaccount" {
    name                        = "diag${random_id.randomId.hex}"
    resource_group_name         = azurerm_resource_group.myterraformgroup.name
    location                    = "eastus2"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "empresa"
    }
}

resource "azurerm_storage_share" "empresashare" {
  name                 = "financeiro"
  storage_account_name = azurerm_storage_account.mystorageaccount.name
  quota                = 100
}