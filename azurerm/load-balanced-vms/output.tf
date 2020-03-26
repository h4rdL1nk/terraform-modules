output "vm-ids" {
  value = azurerm_linux_virtual_machine.main[*].id
}

output "lb-fqdn" {
  value = azurerm_public_ip.lbs.fqdn
}