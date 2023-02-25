#
# Create the app service plan for the function apps...
#
resource "azurerm_app_service_plan" "plan" {
  name                = "${var.name}-${var.platform}-${var.region}-${var.environment}-plan"
  location            = var.resgroup_main_location
  resource_group_name = var.resgroup_main_name
  kind                = "FunctionApp"
#v3
#  kind                = "Linux"
#  reserved            = true

  sku {
    tier = "Standard"
    size = "S1"
  }

  tags = var.tags
}

#
# Create our App Insights resource...
#
resource "azurerm_application_insights" "func_app" {
  name                = "${var.name}-${var.platform}-${var.region}-${var.environment}-appinsights"
  location            = var.resgroup_main_location
  resource_group_name = var.resgroup_main_name
  application_type    = "web"
  tags                = var.tags
}

#
# Create the Funtion App...
#
resource "azurerm_function_app" "func_app" {
  name                        = "${var.name}-${var.platform}-${var.region}-${var.environment}-funcapp"
  location                    = var.resgroup_main_location
  resource_group_name         = var.resgroup_main_name
  app_service_plan_id         = azurerm_app_service_plan.plan.id
  storage_account_name        = var.storage_account_name
  storage_account_access_key  = var.storage_account_access_key 

  version = "~2"
#v3
#  os_type                    = "linux"
#  version                    = "~3"  

  app_settings = {
    APPINSIGHTS_INSTRUMENTATIONKEY           = azurerm_application_insights.func_app.instrumentation_key
    AzureWebJobsDashboard                    = var.storage_account_conn_string
    AzureWebJobsStorage                      = var.storage_account_conn_string
    AzureWebJobsDisableHomepage              = "true"
    COSMOS_DB_CONNECTION_STRING              = "AccountEndpoint=${var.cosmosdb_endpoint};AccountKey=${var.cosmosdb_primary_key};"
    EVENTGRID_SAS_KEY                        = var.eventgrid_primary_access_key
    EVENTGRID_TOPIC_ENDPOINT                 = var.eventgrid_endpoint
    FUNCTIONS_EXTENSION_VERSION              = "~2"
    FUNCTIONS_WORKER_RUNTIME                 = "dotnet"
    WEBSITE_CONTENTSHARE                     = var.storage_account_name
    WEBSITE_NODE_DEFAULT_VERSION             = "8.11.1"
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING = var.storage_account_conn_string
  }

  #Set these varaibles after the vnet integration is done for a function app....otherwise, nothing will work and you will chase your tail for days, weeks, months...okay, for some time....do this last after vnet integration is setup for a function app!!!!!    
  #    WEBSITE_DNS_ALT_SERVER         = "${var.dns_alt_server}"
  #    WEBSITE_DNS_SERVER             = "${var.dns_server}"

  site_config {
    use_32_bit_worker_process = false
    always_on                 = true

    cors{
      support_credentials     = true
      allowed_origins         = [var.static_website_url]
    }
  }

  tags = var.tags
}

#
# Enroll the function app in VNET-Integration
#
resource "azurerm_app_service_virtual_network_swift_connection" "swift_conn" {
  app_service_id = azurerm_function_app.func_app.id
  subnet_id      = var.subnet2_id
}


#
# Create the app insights apikey...
#
resource "azurerm_application_insights_api_key" "full_permissions" {
  name                    = "${var.name}-${var.platform}-${var.region}-${var.environment}-appinsights-api-key"
  application_insights_id = azurerm_application_insights.func_app.id
  read_permissions        = ["agentconfig", "aggregate", "api", "draft", "extendqueries", "search"]
  write_permissions       = ["annotations"]
}

