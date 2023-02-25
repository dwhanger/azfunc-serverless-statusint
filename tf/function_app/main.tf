#
# Tyee Software Inc. (c) 2023
#

#
# Configure the Azure Provider
#
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.59.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      version = "1.4.0"
    }
  }
}

provider "azuread" {
  # Configuration options
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = false
      #
      # not compatible with byok ADF keyvault setup, retrieval, and encryption...
      #
      #recover_soft_deleted_key_vaults = true
    }
  }
//  skip_credentials_validation
}

data "azurerm_client_config" "current" {}

#
# Define our resource tags we will apply to every resource...
#
locals {
  tags = {
    BusinessUnit    = "Tyee Software"
    CostCenter      = "100-32555-000"
    Environment     = var.environment
    SXAPPID         = var.sxappid
    AppName         = var.name
    OwnerEmail      = var.owner_email
    Platform        = var.platform
    PlatformAppName = "${var.platform}${var.name}"
  }
}


#
# Our main resource group...
#
resource "azurerm_resource_group" "main" {
  name     = "${var.name}-${var.platform}-${var.region}-${var.environment}-rg"
  location = var.location

  tags = local.tags
}


#
# Load up our module where we have the vnet, nsgs, and subnets defined...
#
module "azure_vnet_nsg_subnet" {
  source = "./modules/azure-vnet-nsg-subnet"

  resgroup_main_location      = azurerm_resource_group.main.location
  resgroup_main_name          = azurerm_resource_group.main.name
  name                        = var.name
  location                    = var.location
  platform                    = var.platform
  region                      = var.region
  environment                 = var.environment
  vnet_address_space          = var.vnet_address_space
  subnet_address_prefix_web   = var.subnet_address_prefix_web
  subnet_address_prefix_app   = var.subnet_address_prefix_app
  subnet_address_prefix_db    = var.subnet_address_prefix_db
  tags                        = local.tags
}

#
# Load up out module where our storage accounts are defined for the function app and for the content for the single page application (SPA)
#
module "azure_storage_accounts" {
  source = "./modules/azure-storage-accounts"

  resgroup_main_location      = azurerm_resource_group.main.location
  resgroup_main_name          = azurerm_resource_group.main.name
  name                        = var.name
  location                    = var.location
  platform                    = var.platform
  region                      = var.region
  environment                 = var.environment
  subnet1_id                  = module.azure_vnet_nsg_subnet.subnet1_id
  ip_to_allow                 = "76.138.138.227"
  tags                        = local.tags
}


#
# Our REST api's are backed by CosmosDB (sql api)...
#
module "azure_cosmosdb" {
  source = "./modules/azure-cosmosdb"

  resgroup_main_location      = azurerm_resource_group.main.location
  resgroup_main_name          = azurerm_resource_group.main.name
  name                        = var.name
  location                    = var.location
  platform                    = var.platform
  region                      = var.region
  environment                 = var.environment
  subnet3_id                  = module.azure_vnet_nsg_subnet.subnet3_id
  ip_to_allow                 = "76.138.138.227"
  tags                        = local.tags
}

resource "azurerm_eventgrid_topic" "eventgrid" {
  depends_on = [azurerm_resource_group.main]

  name                ="${var.name}-${var.platform}-${var.region}-${var.environment}-topic"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  tags                = local.tags
}


#
# Our REST api's are backed by CosmosDB (sql api)...
#
module "azure_functionapp_premium" {
  source = "./modules/azure-functionapp-premium"

  resgroup_main_location      = azurerm_resource_group.main.location
  resgroup_main_name          = azurerm_resource_group.main.name
  name                        = var.name
  location                    = var.location
  platform                    = var.platform
  region                      = var.region
  environment                 = var.environment
  subnet2_id                  = module.azure_vnet_nsg_subnet.subnet2_id
  ip_to_allow                 = "76.138.138.227"
  storage_account_name        = module.azure_storage_accounts.func_app_sa_name
  storage_account_access_key  = module.azure_storage_accounts.func_app_sa_primary_access_key 
  storage_account_conn_string = module.azure_storage_accounts.func_app_sa_connection_string
  cosmosdb_endpoint           = module.azure_cosmosdb.cosmosdb_endpoint
  cosmosdb_primary_key        = module.azure_cosmosdb.cosmosdb_primary_key
  eventgrid_primary_access_key= azurerm_eventgrid_topic.eventgrid.primary_access_key
  eventgrid_endpoint          = azurerm_eventgrid_topic.eventgrid.endpoint
  static_website_url          = module.azure_storage_accounts.static_website_url
  tags                        = local.tags
}


#
# az keyvault secret show --name "vsts-pat-dev-azure-com-azx-tyeesoftware" --vault-name "terraform-akv" --query value --output tsv
#
# Note: az command works from the command line but not from within TF.....using the tf object model below, works like a champ!
#
data "azurerm_key_vault" "terraform_akv" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_resourcegroup
}

data "azurerm_key_vault_secret" "vsts_pat_keyvault_secret" {
  depends_on = [data.azurerm_key_vault.terraform_akv]

  name         = "vsts-pat-dev-azure-com-azx-tyeesoftware"
  key_vault_id = data.azurerm_key_vault.terraform_akv.id
}

data "azurerm_key_vault_secret" "vsts_username_keyvault_secret" {
  depends_on = [data.azurerm_key_vault.terraform_akv]

  name         = "vsts-username-dev-azure-com-azx-tyeesoftware"
  key_vault_id = data.azurerm_key_vault.terraform_akv.id
}


#
# PUT the Azure DevOps Library variables to the project in ADO...
#
module "azure_devops_library" {
  source = "./modules/azure-devops-library"

  resgroup_main_location                                  = azurerm_resource_group.main.location
  resgroup_main_name                                      = azurerm_resource_group.main.name
  name                                                    = var.name
  location                                                = var.location
  platform                                                = var.platform
  region                                                  = var.region
  environment                                             = var.environment
  ip_to_allow                                             = "76.138.138.227"
  storage_account_name                                    = module.azure_storage_accounts.func_app_sa_name
  storage_account_access_key                              = module.azure_storage_accounts.func_app_sa_primary_access_key 
  storage_account_conn_string                             = module.azure_storage_accounts.func_app_sa_connection_string
  cosmosdb_endpoint                                       = module.azure_cosmosdb.cosmosdb_endpoint
  cosmosdb_primary_key                                    = module.azure_cosmosdb.cosmosdb_primary_key
  eventgrid_primary_access_key                            = azurerm_eventgrid_topic.eventgrid.primary_access_key
  eventgrid_endpoint                                      = azurerm_eventgrid_topic.eventgrid.endpoint
  static_website_url                                      = module.azure_storage_accounts.static_website_url
  ADO_library_ADAL_ACCESS_TOKEN                           = var.ADO_library_ADAL_ACCESS_TOKEN
  application_insights_api_key_full_permissions_api_key   = module.azure_functionapp_premium.application_insights_api_key_full_permissions_api_key
  application_insights_func_app_app_id                    = module.azure_functionapp_premium.application_insights_func_app_app_id
  application_insights_func_app_instrumentation_key       = module.azure_functionapp_premium.application_insights_func_app_instrumentation_key
  func_app_sa_connection_string                           = module.azure_storage_accounts.func_app_sa_connection_string
  func_app_sa_name                                        = module.azure_storage_accounts.func_app_sa_name
  ADO_library_AZURE_APP_ISSUER                            = var.ADO_library_AZURE_APP_ISSUER
  ADO_library_appsettings_AZURE_APP_TENANT_ID             = var.ADO_library_appsettings_AZURE_APP_TENANT_ID
  ADO_library_AzureWebJobsSendGridApiKey                  = var.ADO_library_AzureWebJobsSendGridApiKey
  ADO_library_dynatraceApi                                = var.ADO_library_dynatraceApi
  ADO_library_dynatraceToken                              = var.ADO_library_dynatraceToken
  ADO_library_FUNCTIONS_EXTENSION_VERSION                 = var.ADO_library_FUNCTIONS_EXTENSION_VERSION
  ADO_library_FUNCTIONS_WORKER_RUNTIME                    = var.ADO_library_FUNCTIONS_WORKER_RUNTIME
  ADO_library_loginData                                   = var.ADO_library_loginData
  ADO_library_loginUrl                                    = var.ADO_library_loginUrl
  ADO_library_NotificationSender                          = var.ADO_library_NotificationSender
  ADO_library_slackApi                                    = var.ADO_library_slackApi
  ADO_library_slackToken                                  = var.ADO_library_slackToken
  ADO_library_statusUrl                                   = var.ADO_library_statusUrl
  ADO_library_TimerRecipient                              = var.ADO_library_TimerRecipient
  ADO_library_VSTS_InstanceName                           = var.ADO_library_VSTS_InstanceName
  vsts_pat_keyvault_secret                                = data.azurerm_key_vault_secret.vsts_pat_keyvault_secret.value
  vsts_username_keyvault_secret                           = data.azurerm_key_vault_secret.vsts_username_keyvault_secret.value
  ADO_library_VSTS_ProjectName                            = var.ADO_library_VSTS_ProjectName
  ADO_library_WEBSITE_NODE_DEFAULT_VERSION                = var.ADO_library_WEBSITE_NODE_DEFAULT_VERSION
  dns_alt_server                                          = var.dns_alt_server
  dns_server                                              = var.dns_server
  ADO_library_AZURE_APP_CLIENT_ID                         = var.ADO_library_AZURE_APP_CLIENT_ID
  ADO_library_AZURE_APP_TENANT_ID                         = var.ADO_library_AZURE_APP_TENANT_ID
  func_app_default_hostname                               = module.azure_functionapp_premium.func_app_default_hostname
  ADO_organization_url                                    = var.ADO_organization_url
  ADO_project                                             = var.ADO_project
  ADO_library_groupid                                     = var.ADO_library_groupid
  ADO_library_name                                        = var.ADO_library_name
  tags                                                    = local.tags
}


#
# Kick off release of code... 
#
resource "null_resource" "kick_off_release_to_deploy_code_to_stack" {
#  depends_on = [null_resource.update_the_library_group_variables_for_all_just_generated_ids_connection_strings_and_apikeys]

  /*
  #
  # Kick off the build for the status-int-master project....
  #
  #az pipelines build queue --definition-id 15 --organization https://azx-tyeesoftware.visualstudio.com --project devops
  #
  provisioner "local-exec" {
    command = "az pipelines build queue --definition-id ${var.ADO_build_id} --organization ${var.ADO_organization_url} --project ${var.ADO_project}"
    on_failure = "continue"
  }
*/

  #
  # Kick off a release of the status-int-master project from the latest package....
  #
  # az pipelines release create --definition-id 6 --organization https://dev.azure.com/azx-tyeesoftware --project devops
  #
  provisioner "local-exec" {
    command    = "az pipelines release create --output table --definition-id ${var.ADO_release_id} --organization ${var.ADO_organization_url} --project ${var.ADO_project}"
    on_failure = continue
  }

  #
  # Once the functions are deployed via the build above, create the eventgrid topic subscriptions for each function for dynatrace and http....
  #
}

//todo, make execution of EventGrid subscription conditional on the code being deployed...
/*
#
# For the EventGrid subscription registrations below to work, the code for the Azure Functions must have already been deployed successfully...
#
# az eventgrid event-subscription create --name EndPointCheckerDynatrace --endpoint '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.Web/sites/${azurerm_function_app.func_app.name}/functions/EndPointCheckerTypeDynatrace' --endpoint-type azurefunction --subject-begins-with Dynatrace --subject-case-sensitive false --event-delivery-schema eventgridschema --labels functions-endpointtypedynatrace --source-resource-id '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}' --subscription ${var.subscriptionid}
resource "azurerm_eventgrid_event_subscription" "egEndPointCheckerDynatrace" {
  name                   = "${var.name}-${var.platform}-${var.region}-${var.environment}-eventgrid-sub-dynatrace"
  scope                  = azurerm_resource_group.main.id

  event_delivery_schema  = "EventGridSchema"
  labels                 = ["functions-endpointtypedynatrace"]

  subject_filter{
    subject_begins_with  = "Dynatrace"
    case_sensitive       = false
  }

# --source-resource-id '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}'
  azure_function_endpoint {
    function_id = "/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}/functions/EndPointCheckerDynatrace"
  }
}


# az eventgrid event-subscription create --name EndPointCheckerHttp --endpoint '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.Web/sites/${azurerm_function_app.func_app.name}/functions/EndPointCheckerTypeHttp' --endpoint-type azurefunction --subject-begins-with Http --subject-case-sensitive false --event-delivery-schema eventgridschema --labels functions-endpointtypehttp --source-resource-id '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}' --subscription ${var.subscriptionid}
resource "azurerm_eventgrid_event_subscription" "egEndPointCheckerHttp" {
  name                   = "${var.name}-${var.platform}-${var.region}-${var.environment}-eventgrid-sub-http"
  scope                  = azurerm_resource_group.main.id

  event_delivery_schema  = "EventGridSchema"
  labels                 = ["functions-endpointtypehttp"]

  subject_filter{
    subject_begins_with  = "Http"
    case_sensitive       = false
  }
# --source-resource-id '/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}' --subscription ${var.subscriptionid}
  azure_function_endpoint {
    function_id = "/subscriptions/${var.subscriptionid}/resourceGroups/${azurerm_resource_group.main.name}/providers/Microsoft.EventGrid/topics/${azurerm_eventgrid_topic.eventgrid.name}/functions/EndPointCheckerHttp"
  }
}
*/