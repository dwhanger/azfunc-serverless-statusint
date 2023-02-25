#
# Output variables...
#
output "cosmosdb_endpoint" {
  description = "CosmosDB endpoint"
  value       = azurerm_cosmosdb_account.cosmosdb.endpoint
}


output "cosmosdb_primary_key" {
  description = "CosmosDB primary key"
  value       = azurerm_cosmosdb_account.cosmosdb.primary_key
}
