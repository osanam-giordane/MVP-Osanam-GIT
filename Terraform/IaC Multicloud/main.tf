# Configure the Microsoft Azure Provider
provider "azurerm" {
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
    features{}
}
# Configure the AWS Provider
provider "aws" {
  version = "~> 2.0"
  region  = "us-east-1"
}

provider "aws" {
  alias = "us-east-2"
  version = "~> 2.0"
  region  = "us-east-2"
}

### Microsoft AZURE

# Create a resource group if it doesn’t exist
resource "azurerm_resource_group" "myterraformgroup" {
    name     = "empresa-rg"
    location = "eastus"

    tags = {
        environment = "empresa"
    }
}

# Create virtual network
resource "azurerm_virtual_network" "myterraformnetwork" {
    name                = "empresa-vnet"
    address_space       = ["10.0.0.0/16"]
    location            = "eastus"
    resource_group_name = azurerm_resource_group.myterraformgroup.name

    tags = {
        environment = "empresa"
    }
}

# Create subnet
resource "azurerm_subnet" "myterraformsubnet" {
    name                 = "empresaSubnet"
    resource_group_name  = azurerm_resource_group.myterraformgroup.name
    virtual_network_name = azurerm_virtual_network.myterraformnetwork.name
    address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet_network_security_group_association" "nsgsubnet" {
  subnet_id                 = azurerm_subnet.myterraformsubnet.id
  network_security_group_id = azurerm_network_security_group.myterraformnsg.id
}

# Create public IPs Linux01
resource "azurerm_public_ip" "myterraformpublicip" {
    name                         = "LINUX01PIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "empresa"
    }
}

# Create public IPs Linux02
resource "azurerm_public_ip" "myterraformpublicip2" {
    name                         = "LINUX02PIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "empresa"
    }
}

# Create public IPs Linux03
resource "azurerm_public_ip" "myterraformpublicip3" {
    name                         = "LINUX03PIP"
    location                     = "eastus"
    resource_group_name          = azurerm_resource_group.myterraformgroup.name
    allocation_method            = "Dynamic"

    tags = {
        environment = "empresa"
    }
}

# Create Network Security Group and rule Linux01
resource "azurerm_network_security_group" "myterraformnsg" {
    name                = "empresa-nsg"
    location            = "eastus"
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

# Create network interface Linux01

resource "azurerm_network_interface" "myterraformnic" {
    name                      = "LINUX01NIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "LINUX01NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip.id
    }

    tags = {
        environment = "empresa"
    }
}

# Create network interface Linux02

resource "azurerm_network_interface" "myterraformnic2" {
    name                      = "LINUX02NIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "LINUX02NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip2.id
    }

    tags = {
        environment = "empresa"
    }
}

# Create network interface Linux03

resource "azurerm_network_interface" "myterraformnic3" {
    name                      = "LINUX03NIC"
    location                  = "eastus"
    resource_group_name       = azurerm_resource_group.myterraformgroup.name

    ip_configuration {
        name                          = "LINUX03NicConfiguration"
        subnet_id                     = azurerm_subnet.myterraformsubnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.myterraformpublicip3.id
    }

    tags = {
        environment = "empresa"
    }
}

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
    location                    = "eastus"
    account_tier                = "Standard"
    account_replication_type    = "LRS"

    tags = {
        environment = "empresa"
    }
}

# Create virtual machine Linux01
resource "azurerm_virtual_machine" "myterraformvm" {
    name                  = "LINUX01VM"
    location              = "eastus"
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
    location              = "eastus"
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
    location              = "eastus"
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

### AWS Provider
resource "aws_instance" "dev" {
    count = 3
    ami = "ami-085925f297f89fce1"
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
        Name = "dev${count.index}"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}","${aws_security_group.allow_rdp.id}"]
}

resource "aws_instance" "dev8" {
    ami = var.amis["us-east-1"]
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
        Name = "dev8"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh.id}"]
    depends_on = [aws_s3_bucket.dev11]
}

resource "aws_instance" "dev9" {
    provider = "aws.us-east-2"
    ami = var.amis["us-east-2"]
    instance_type = "t2.micro"
    key_name = "empresa-terraform"
    tags = {
        Name = "dev9"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh-us-east-2.id}"]
    depends_on = ["aws_dynamodb_table.dynamodb-hom"]
}

resource "aws_instance" "dev10" {
    provider = "aws.us-east-2"
    ami = var.amis["us-east-2"]
    instance_type = "t2.micro"
    key_name = var.key_name
    tags = {
        Name = "dev10"
    }
    vpc_security_group_ids = ["${aws_security_group.allow_ssh-us-east-2.id}"]
}

resource "aws_dynamodb_table" "dynamodb-hom" {
  provider = "aws.us-east-2"
  name           = "GameScores"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserId"
  range_key      = "GameTitle"

  attribute {
    name = "UserId"
    type = "S"
  }

  attribute {
    name = "GameTitle"
    type = "S"
  }
}
resource "aws_s3_bucket" "dev11" {
  bucket = "empresalabs-11"
  acl    = "private"

  tags = {
    Name = "empresalabs-dev11"
  }
}