# Input variable definitions
#
variable "tags" {
  description = "Tags to set on the resource"
  type        = map(string)
  default     = {}
}

variable "resgroup_main_name" {
  description = "The main resource group name"
  default     = ""
}

variable "resgroup_main_location" {
  description = "The main resource group location"
  default     = ""
}

variable "name" {
  description = "Name to be used as basis for all resources."
  default     = ""
}

variable "location" {
  description = "Azure region."
  default     = ""
}

variable "region" {
  description = "The region site code "
  default     = ""
}

variable "environment" {
  description = "The environment code (e.g. devint, qa, stage, prod)"
  default     = "devint"
}

variable "platform" {
  description = "Platform for tagging"
  default     = ""
}

variable "ip_to_allow" {
  description = ""
  default     = ""
}

variable "storage_account_name" {
  description = ""
  default     = ""
}
variable "storage_account_access_key" {
  description = ""
  default     = ""
}
variable "storage_account_conn_string" {
  description = ""
  default     = ""
}
variable "cosmosdb_endpoint" {
  description = ""
  default     = ""
}
variable "cosmosdb_primary_key" {
  description = ""
  default     = ""
}
variable "eventgrid_primary_access_key" {
  description = ""
  default     = ""
}
variable "eventgrid_endpoint" {
  description = ""
  default     = ""
}
variable "static_website_url" {
  description = ""
  default     = ""
}
variable "ADO_library_ADAL_ACCESS_TOKEN" {
  description = ""
  default     = ""
}
variable "application_insights_api_key_full_permissions_api_key" {
  description = ""
  default     = ""
}
variable "application_insights_func_app_app_id" {
  description = ""
  default     = ""
}
variable "application_insights_func_app_instrumentation_key" {
  description = ""
  default     = ""
}
variable "func_app_sa_connection_string" {
  description = ""
  default     = ""
}
variable "func_app_sa_name" {
  description = ""
  default     = ""
}
variable "ADO_library_AZURE_APP_ISSUER" {
  description = ""
  default     = ""
}
variable "ADO_library_appsettings_AZURE_APP_TENANT_ID" {
  description = ""
  default     = ""
}
variable "ADO_library_AzureWebJobsSendGridApiKey" {
  description = ""
  default     = ""
}
variable "ADO_library_dynatraceApi" {
  description = ""
  default     = ""
}
variable "ADO_library_dynatraceToken" {
  description = ""
  default     = ""
}
variable "ADO_library_FUNCTIONS_EXTENSION_VERSION" {
  description = ""
  default     = ""
}
variable "ADO_library_FUNCTIONS_WORKER_RUNTIME" {
  description = ""
  default     = ""
}
variable "ADO_library_loginData" {
  description = ""
  default     = ""
}
variable "ADO_library_loginUrl" {
  description = ""
  default     = ""
}
variable "ADO_library_NotificationSender" {
  description = ""
  default     = ""
}
variable "ADO_library_slackApi" {
  description = ""
  default     = ""
}
variable "ADO_library_slackToken" {
  description = ""
  default     = ""
}
variable "ADO_library_statusUrl" {
  description = ""
  default     = ""
}
variable "ADO_library_TimerRecipient" {
  description = ""
  default     = ""
}
variable "ADO_library_VSTS_InstanceName" {
  description = ""
  default     = ""
}
variable "vsts_pat_keyvault_secret" {
  description = ""
  default     = ""
}
variable "vsts_username_keyvault_secret" {
  description = ""
  default     = ""
}
variable "ADO_library_VSTS_ProjectName" {
  description = ""
  default     = ""
}
variable "ADO_library_WEBSITE_NODE_DEFAULT_VERSION" {
  description = ""
  default     = ""
}
variable "dns_alt_server" {
  description = ""
  default     = ""
}
variable "dns_server" {
  description = ""
  default     = ""
}
variable "ADO_library_AZURE_APP_CLIENT_ID" {
  description = ""
  default     = ""
}
variable "ADO_library_AZURE_APP_TENANT_ID" {
  description = ""
  default     = ""
}
variable "func_app_default_hostname" {
  description = ""
  default     = ""
}
variable "ADO_library_name" {
  description = ""
  default     = ""
}
variable "ADO_organization_url" {
  description = ""
  default     = ""
}

variable "ADO_project" {
  description = ""
  default     = ""
}
variable "ADO_library_groupid" {
  description = ""
  default     = ""
}


