resource "azurerm_virtual_network" "cloudaut-network" {
  name                = "cloudaut-network"
  location            = azurerm_resource_group.cloudaut-resource.location
  resource_group_name = azurerm_resource_group.cloudaut-resource.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Production"
    faculdade   = "Impacta"
  }
}

resource "azurerm_subnet" "cloudaut-subnet" {
  name                 = "cloudaut-subnet"
  resource_group_name  = azurerm_resource_group.cloudaut-resource.name
  virtual_network_name = azurerm_virtual_network.cloudaut-network.name
  address_prefixes     = ["10.0.1.0/24"]

}

resource "azurerm_network_security_group" "cloudaut-sgp" {
  name                = "cloudaut-sgp"
  location            = azurerm_resource_group.cloudaut-resource.location
  resource_group_name = azurerm_resource_group.cloudaut-resource.name

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

   security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "Production"
  }
}
