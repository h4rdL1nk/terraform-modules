
resource "azurerm_network_interface" "main" {
  count = var.number

  name                = "${format("%s-%02d", var.name, count.index + 1)}"
  location            = var.rg_location
  resource_group_name = var.rg_name

  ip_configuration {
    primary = true
    name                          = "main"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

}

resource "azurerm_availability_set" "main" {
  name                = var.name
  location            = var.rg_location
  resource_group_name = var.rg_name

  tags = var.tags
}

resource "azurerm_linux_virtual_machine" "main" {
  count = var.number

  name                = "${format("%s-%02d", var.name, count.index + 1)}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  size                = var.instance_size

  availability_set_id = azurerm_availability_set.main.id

  admin_username = var.ssh_admin_user
  admin_ssh_key {
    username   = var.ssh_admin_user
    public_key = var.ssh_public_key
  }

  network_interface_ids = [ azurerm_network_interface.main[count.index].id ]

  tags = var.tags

  source_image_reference {
    publisher = var.vm_image_reference.publisher
    offer     = var.vm_image_reference.offer
    sku       = var.vm_image_reference.sku
    version   = var.vm_image_reference.version
  }

  os_disk {
    name              = "osDisk-${format("%s-%02d", var.name, count.index + 1)}"
    caching           = "ReadWrite"
    storage_account_type = var.storage_os_disk_type
  }

}
