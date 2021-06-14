# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "empresa-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = azurerm_resource_group.myterraformgroup.location
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = "empresa"
    }
}

#Create Bastion on the same network
resource "azurerm_subnet" "bastionnetwork" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.myterraformgroup.name
  virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
  address_prefixes     = ["10.0.2.0/27"]
}

resource "azurerm_public_ip" "bastionpip" {
  name                = "empresabastionpip"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion" {
  name                = "empresabastion"
  location            = azurerm_resource_group.myterraformgroup.location
  resource_group_name = azurerm_resource_group.myterraformgroup.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastionnetwork.id
    public_ip_address_id = azurerm_public_ip.bastionpip.id
  }
}
# Create subnet servers
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "server-subnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes     = ["10.0.1.0/24"]
}
resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
  subnet_id                 = azurerm_subnet.myterraformsubnet.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create network interface Linux01

resource "azurerm_network_interface" "myterraformnic" {
    name                      = "LINUX01NIC"
    location                  = "eastus2"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "LINUX01NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment = "empresa"
    }
}

# Create network interface Linux02

resource "azurerm_network_interface" "myterraformnic2" {
    name                      = "LINUX02NIC"
    location                  = "eastus2"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "LINUX02NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment = "empresa"
    }
}

# Create network interface Linux03

resource "azurerm_network_interface" "myterraformnic3" {
    name                      = "LINUX03NIC"
    location                  = "eastus2"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "LINUX03NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
    }

    tags = {
        environment = "empresa"
    }
}