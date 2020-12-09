resource "azurerm_virtual_network" "cdn-uksouth-vnet" {
 name                = "cdn-uksouth-vnet"
 address_space       = ["10.0.0.0/16"]
 location            = "UK South"
 resource_group_name = azurerm_resource_group.cdn.name
}

resource "azurerm_subnet" "cdn-uksouth-subnet" {
 name                 = "cdn-uksouth-subnet"
 resource_group_name  = azurerm_resource_group.cdn.name
 virtual_network_name = azurerm_virtual_network.cdn-uksouth-vnet.name
 address_prefixes       = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "cdn-uksouth-01-ip" {
 name                         = "cdn-uksouth-01-ip"
 location                     = "UK South"
 resource_group_name          = azurerm_resource_group.cdn.name
 allocation_method            = "Static"
 domain_name_label            = "cdn-galenguyer-01"
}

resource "azurerm_network_security_group" "cdn-uksouth-01-nsg" {
    name                = "cdn-uksouth-01-nsg"
    location            = "uksouth"
    resource_group_name = azurerm_resource_group.cdn.name

    security_rule {
        name                       = "SSH"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTP"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
    security_rule {
        name                       = "HTTPS"
        priority                   = 1003
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "443"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}

resource "azurerm_network_interface" "cdn-uksouth-01-nic" {
    name                        = "cdn-uksouth-01-nic"
    location                    = "uksouth"
    resource_group_name         = azurerm_resource_group.cdn.name

    ip_configuration {
        name                          = "cdn-uksouth-01-nic-config"
        subnet_id                     = azurerm_subnet.cdn-uksouth-subnet.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.cdn-uksouth-01-ip.id
    }
}

resource "azurerm_network_interface_security_group_association" "cdn-uksouth-01-nic-nsg-association" {
    network_interface_id      = azurerm_network_interface.cdn-uksouth-01-nic.id
    network_security_group_id = azurerm_network_security_group.cdn-uksouth-01-nsg.id
}

resource "azurerm_linux_virtual_machine" "cdn-uksouth-01" {
    name                  = "cdn-uksouth-01"
    location              = "uksouth"
    resource_group_name   = azurerm_resource_group.cdn.name
    network_interface_ids = [azurerm_network_interface.cdn-uksouth-01-nic.id]
    size                  = "Standard_B1ls"

    os_disk {
        caching           = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "Debian"
        offer     = "debian-10"
        sku       = "10"
        version   = "latest"
    }

    admin_username = "chef"
    disable_password_authentication = true

    admin_ssh_key {
        username       = "chef"
        public_key = file("~/.ssh/id_rsa.pub")
    }
}
