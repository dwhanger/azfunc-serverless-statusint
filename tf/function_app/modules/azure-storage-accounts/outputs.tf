#
# Output variables...
#
output "static_website_url" {
  description = "Static website url for SPA pages"
  value       = data.azurerm_storage_account.static_website_url.primary_web_endpoint
}

output "func_app_sa_connection_string" {
  description = "Storage Account for Azure Function"
  value       = azurerm_storage_account.func_app.primary_connection_string
}

output "func_app_sa_name" {
  description = "Name of Storage Account for Azure Function"
  value       = azurerm_storage_account.func_app.name
}

output "static_website_url_primary_location" {
  description = "Static website primary location"
  value       = azurerm_storage_account.webstatic_files.primary_location
}

output "static_website_files_name" {
  description = "Static website files name"
  value       = azurerm_storage_account.webstatic_files.name
}

output "func_app_sa_primary_access_key" {
  description = "Primary Access Key of Storage Account for Azure Function"
  value       = azurerm_storage_account.func_app.primary_access_key
}


