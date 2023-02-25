output "AppInsightsApiKey" {
  sensitive = true
  value = module.azure_functionapp_premium.application_insights_api_key_full_permissions_api_key
}

output "AppInsightsApp" {
  value = module.azure_functionapp_premium.application_insights_func_app_app_id
}

output "appsetting-APPINSIGHTS_INSTRUMENTATIONKEY" {
  sensitive = true
  value = module.azure_functionapp_premium.application_insights_func_app_instrumentation_key
}

output "appsetting-AzureWebJobsDashboard" {
  sensitive = true
  value = module.azure_storage_accounts.func_app_sa_connection_string
}

output "appsetting-AzureWebJobsStorage" {
  sensitive = true
  value = module.azure_storage_accounts.func_app_sa_connection_string 
}

output "appsetting-COSMOS_DB_CONNECTION_STRING" {
  sensitive = true
  value = "AccountEndpoint=${module.azure_cosmosdb.cosmosdb_endpoint};AccountKey=${module.azure_cosmosdb.cosmosdb_primary_key};"
}

output "appsetting-EVENTGRID_SAS_KEY" {
  sensitive = true
  value = azurerm_eventgrid_topic.eventgrid.primary_access_key
}

output "appsetting-EVENTGRID_TOPIC_ENDPOINT" {
  value = azurerm_eventgrid_topic.eventgrid.endpoint
}

output "appsetting-WEBSITE_CONTENTAZUREFILECONNECTIONSTRING" {
  sensitive = true
  value = module.azure_storage_accounts.func_app_sa_connection_string
}

output "appsetting-WEBSITE_CONTENTSHARE" {
  value = module.azure_storage_accounts.func_app_sa_name
}

output "AZURE_APP_REDIRECT_URI" {
  value = trimspace(module.azure_storage_accounts.static_website_url)
}

output "functionapp_info_default_hostname" {
  value = module.azure_functionapp_premium.func_app_default_hostname 
}

output "functionapp_info_outbound_ip_addresses" {
  value = module.azure_functionapp_premium.func_app_outbound_ip_addresses
}

output "storageaccount_webstatic_info_primary_location" {
  value = module.azure_storage_accounts.static_website_url_primary_location
}

output "app_service_plan_info_maxnumber_of_workers" {
  value = module.azure_functionapp_premium.app_service_plan_info_maxnumber_of_workers
}

output "function_app_name" {
  value = module.azure_functionapp_premium.func_app_name
}

output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "web_storage_account" {
  value = module.azure_storage_accounts.static_website_files_name
}

/*
output "zzzzz_eventgrid_dynatrace_to_run_after_deploy" {
  value = "az eventgrid event-subscription create --name EndPointCheckerDynatrace --endpoint 'https://${azurerm_function_app.func_app.default_hostname}/runtime/webhooks/EventGrid?functionName=EndPointTypeDynatrace' --endpoint-type webhook --subject-begins-with Dynatrace --subject-case-sensitive false --event-delivery-schema eventgridschema --labels functions-endpointtypedynatrace --source-resource-id '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}' --subscription ${var.subscriptionid}"
}

output "zzzzz_eventgrid_http_to_run_after_deploy" {
  value = "az eventgrid event-subscription create --name EndPointCheckerHttp --endpoint 'https://${azurerm_function_app.func_app.default_hostname}/runtime/webhooks/EventGrid?functionName=EndPointTypeHttp' --endpoint-type webhook --subject-begins-with Http --subject-case-sensitive false --event-delivery-schema eventgridschema --labels functions-endpointtypehttp --source-resource-id '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}' --subscription ${var.subscriptionid}"
}

*/
