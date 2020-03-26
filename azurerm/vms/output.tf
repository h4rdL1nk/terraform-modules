output "vm-ids" {
  value = azurerm_linux_virtual_machine.main[*].id
}