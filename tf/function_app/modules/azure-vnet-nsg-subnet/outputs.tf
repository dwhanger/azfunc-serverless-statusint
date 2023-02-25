# Output variable definitions

output "subnet1_id" {
  description = "Subnet 1 ID (web)"
  value       = azurerm_subnet.subnet1.id
}

output "subnet2_id" {
  description = "Subnet 2 ID (app)"
  value       = azurerm_subnet.subnet2.id
}

output "subnet3_id" {
  description = "Subnet 3 ID (db)"
  value       = azurerm_subnet.subnet3.id
}


