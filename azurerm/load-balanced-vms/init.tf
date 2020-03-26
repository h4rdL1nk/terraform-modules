
resource "azurerm_public_ip" "lbs" {
  name                         = "lb-pip-${var.name}"
  location                     = var.rg_location
  resource_group_name          = var.rg_name
  allocation_method            = "Static"
  domain_name_label            = "${var.domain_prefix}-${var.name}"
}

resource "azurerm_lb" "main" {
  name                = "lb-${var.name}"
  location            = var.rg_location
  resource_group_name = var.rg_name

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.lbs.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  name                = var.name
  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.main.id  
}

resource "azurerm_lb_probe" "main" {
  for_each = var.ports

  resource_group_name = var.rg_name
  loadbalancer_id     = azurerm_lb.main.id
  name                = each.key
  port                = each.value.int_port
}

resource "azurerm_lb_rule" "main" {
  for_each = var.ports

  resource_group_name            = var.rg_name
  loadbalancer_id                = azurerm_lb.main.id
  name                           = each.key
  protocol                       = each.value.proto
  frontend_port                  = each.value.ext_port
  backend_port                   = each.value.int_port
  backend_address_pool_id        = azurerm_lb_backend_address_pool.main.id
  frontend_ip_configuration_name = "PublicIPAddress"
  probe_id                       = azurerm_lb_probe.main[each.key].id
}

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

resource "azurerm_network_interface_backend_address_pool_association" "main" {
  count = var.number

  network_interface_id    = azurerm_network_interface.main[count.index].id
  ip_configuration_name   = "main"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
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
