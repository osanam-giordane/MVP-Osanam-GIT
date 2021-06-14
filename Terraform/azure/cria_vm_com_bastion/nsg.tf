# Create Network Security Group and rule Linux01
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "LINUX-NSG"
    location            = "eastus2"
    resource_group_name = azurerm_resource_group.myterraformgroup.name
    
    security_rule {
        name                       = "SSH"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    tags = {
        environment = "empresa"
    }
}