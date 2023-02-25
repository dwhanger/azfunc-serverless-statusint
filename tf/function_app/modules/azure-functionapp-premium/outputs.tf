#
# Output variables...
#
output "application_insights_api_key_full_permissions_api_key" {
#  sensitive = true
  value = azurerm_application_insights_api_key.full_permissions.api_key
}

output "application_insights_func_app_app_id" {
  value = azurerm_application_insights.func_app.app_id
}

output "application_insights_func_app_instrumentation_key" {
#  sensitive = true
  value = azurerm_application_insights.func_app.instrumentation_key
}

output "func_app_default_hostname" {
  value = azurerm_function_app.func_app.default_hostname
}

output "func_app_outbound_ip_addresses" {
  value = azurerm_function_app.func_app.outbound_ip_addresses
}

output "app_service_plan_info_maxnumber_of_workers" {
  value = azurerm_app_service_plan.plan.maximum_number_of_workers
}

output "func_app_name" {
  value = azurerm_function_app.func_app.name
}

