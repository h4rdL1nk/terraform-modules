### Create public IPs
resource "azurerm_public_ip" "main" {
  count               = "${var.number}"
  name                = "${format("%s-%02d-pip", var.name, count.index + 1)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  allocation_method   = "Dynamic"
}

### Create network interfaces
resource "azurerm_network_interface" "private" {
  count               = "${var.number}"
  name                = "${format("%s-%02d-private", var.name, count.index + 1)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  ip_configuration {
    name                          = "private"
    subnet_id                     = "${var.network_private_id}"
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "public" {
  count               = "${var.number}"
  name                = "${format("%s-%02d-public", var.name, count.index + 1)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  #network_security_group_id = "${azurerm_network_security_group.secgroups["public"].id}"

  ip_configuration {
    name                          = "public"
    subnet_id                     = "${var.network_public_id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.main.*.id,count.index)}"
  }
}

#resource "azurerm_network_interface_application_security_group_association" "public" {
#  count                 = "${var.instances[local.instance_type]["num"]}"
#  network_interface_id  = "${azurerm_network_interface.public.id}"
#  ip_configuration_name = "public"
#  application_security_group_id = "${azurerm_application_security_group.puclic.id}"
#}

### Create VMs
resource "azurerm_virtual_machine" "main" {
  count                   = "${var.number}"
  name                    = "${format("%s-%02d", var.name, count.index + 1)}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"
  vm_size                 = "${var.size}"
  tags                    = "${var.tags}"

  primary_network_interface_id  = "${element(azurerm_network_interface.public.*.id,count.index)}"
  network_interface_ids   = [
      "${element(azurerm_network_interface.private.*.id,count.index)}",
      "${element(azurerm_network_interface.public.*.id,count.index)}"
  ]

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.ssh_admin_user}/.ssh/authorized_keys"
      key_data = "${file("${path.cwd}/keys/${var.ssh_keypair_name}.pubkey")}"
    }
  }

  os_profile {
    computer_name  = "${format("%s-%02d", var.name, count.index + 1)}"
    admin_username = "${var.ssh_admin_user}"
  }

  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "${var.storage_image_publisher}"
    offer     = "${var.storage_image_offer}"
    sku       = "${var.storage_image_sku}"
    version   = "${var.storage_image_version}"
  }

  storage_os_disk {
    name              = "${format("%s-%02d-osdisk", var.name, count.index + 1)}"
    create_option     = "FromImage"
  }

  dynamic "storage_data_disk" {
    for_each = var.storage_volumes
    content {
        name = "${format("%s-%02d-%s", var.name, count.index + 1, storage_data_disk.key)}"
        create_option = "Empty"
        disk_size_gb  = storage_data_disk.value.size
        lun           = storage_data_disk.value.index
    }
  }
}
