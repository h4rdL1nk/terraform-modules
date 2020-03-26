
resource "azurerm_managed_disk" "main" {
  count = length(var.instance-ids)

  name                = "${format("%s-%s-%02d", var.instance-name, var.disk_name, count.index + 1)}"
  location            = var.rg_location
  resource_group_name = var.rg_name
  storage_account_type = var.disk_type
  create_option        = "Empty"
  disk_size_gb         = var.disk_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "gater-sandbox" {
  count = length(var.instance-ids)

  managed_disk_id    = azurerm_managed_disk.main[count.index].id
  virtual_machine_id = var.instance-ids[count.index]
  lun                = var.disk_index
  caching            = "ReadWrite"
}
