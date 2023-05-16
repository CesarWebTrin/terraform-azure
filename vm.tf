resource "azurerm_public_ip" "cloudaut-publicip" {
  name                    = "cloudaut-publicip"
  location                = azurerm_resource_group.cloudaut-resource.location
  resource_group_name     = azurerm_resource_group.cloudaut-resource.name
  allocation_method       = "Static"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "cloudaut-nic" {
  name                = "cloudaut-nic"
  location                = azurerm_resource_group.cloudaut-resource.location
  resource_group_name     = azurerm_resource_group.cloudaut-resource.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.cloudaut-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.cloudaut-publicip.id
  }
}

resource "azurerm_linux_virtual_machine" "cloudaut-vm" {
  name                            = "cloudaut-vm"
  resource_group_name             = azurerm_resource_group.cloudaut-resource.name
  location                        = azurerm_resource_group.cloudaut-resource.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "adminuser"
  admin_password                  = "Teste@1234"
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.cloudaut-nic.id,
  ]


  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}


resource "azurerm_network_interface_security_group_association" "cloudaut-sgpa" {
  network_interface_id      = azurerm_network_interface.cloudaut-nic.id
  network_security_group_id = azurerm_network_security_group.cloudaut-sgp.id
}


resource "null_resource" "install-nginx" {  

  # Bootstrap script can run on any instance of the cluster
  # So we just choose the first in this case
  connection {
    type = "ssh"
    host = azurerm_public_ip.cloudaut-publicip.ip_address
    user = "adminuser"
    password =  "Teste@1234"
  }

  provisioner "remote-exec" {
    # Bootstrap script called with private_ip of each node in the cluster
    inline = [
      "sudo-apt update",
      "sudo apt install -y nginx"
    ]
  }

  depends_on = [
    azurerm_linux_virtual_machine.cloudaut-vm
   ]
}