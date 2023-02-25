variable "subscriptionid" {
  description = "Subscription id for the subscription..."
  default     = ""
}

variable "tenantid" {
  description = "Tenant id for the subscription..."
  default     = ""
}

variable "objectid" {
  description = "Object id for the tf service principal..."
  default     = ""
}

variable "operatorObjectid" {
  description = "Object id for the user operator running the tf script from command line...needed for provisioning the keyvault..."
  default     = ""
}

variable "clientid" {
  description = "Client id for the tf service principal..."
  default     = ""
}


variable "name" {
  description = "Name to be used as basis for all resources."
  default     = "stsint"
}

variable "location" {
  description = "Azure region."
  default     = "southcentralus"
}

variable "region" {
  description = "The region site code "
  default     = "scus"
}

variable "environment" {
  description = "The environment code (e.g. prod)"
  default     = "devint"
}

variable "sxappid" {
  description = "SXAPPID for tagging"
  default     = "50366"
}

variable "owner_email" {
  description = "Owner DL for tagging"
  default     = "dwhanger@hotmail.com"
}

variable "platform" {
  description = "Platform for tagging"
  default     = "webp"
}

variable "dns_alt_server" {
  description = "DNS backup server"
  default     = ""
}

variable "dns_server" {
  description = "DNS server"
  default     = ""
}

variable "vnet_address_space" {
  description = "VNET address space"
  default     = ""
}

variable "subnet_address_prefix_web" {
  description = "Subnet for the web tier"
  default     = ""
}

variable "subnet_address_prefix_app" {
  description = "Subnet for the app tier"
  default     = ""
}

variable "subnet_address_prefix_db" {
  description = "Subnet for the db tier"
  default     = ""
}

variable "eventgrid_ip_whitelisting_1" {
  description = "1st Eventgrid ip address in this region for whitelisting"
  default     = ""
}

variable "eventgrid_ip_whitelisting_2" {
  description = "2nd Eventgrid ip address in this region for whitelisting"
  default     = ""
}

variable "ADO_library_ADAL_ACCESS_TOKEN" {
  description = "the azure devops (tyeesoftware) library ADAL_ACCESS_TOKEN for the reactjs client to use for authenticating the web pages and rest api access"
  default     = ""
}

variable "ADO_library_groupid" {
  description = "the azure devops (tyeesoftware) library groupid to update with the generated variables and apikeys"
  default     = ""
}

variable "ADO_build_id" {
  description = "the azure devops (tyeesoftware) build id number"
  default     = ""
}

variable "ADO_release_id" {
  description = "the azure devops (tyeesoftware) release id number"
  default     = ""
}

variable "ADO_organization_url" {
  description = "the azure devops (tyeesoftware) url to the organization...which is the azx-tyeesoftware part"
  default     = ""
}

variable "ADO_project" {
  description = "the azure devops (tyeesoftware) project setup in tyeesoftware"
  default     = "devops"
}

variable "ADO_library_AZURE_APP_ISSUER" {
  description = "the azure devops (tyeesoftware) library variable for AZURE_APP_ISSUER"
  default     = ""
}

variable "ADO_library_appsettings_AZURE_APP_TENANT_ID" {
  description = "the azure devops (tyeesoftware) library variable for AZURE_APP_TENANT_ID"
  default     = ""
}

variable "ADO_library_AzureWebJobsSendGridApiKey" {
  description = "the azure devops (azx-tyeesoftware) library variable for AzureWebJobsSendGridApiKey"
  default     = ""
}

variable "ADO_library_dynatraceApi" {
  description = "the azure devops (azx-tyeesoftware) library variable for dynatraceApi"
  default     = ""
}

variable "ADO_library_dynatraceToken" {
  description = "the azure devops (tyeesoftware) library variable for dynatraceToken"
  default     = ""
}

variable "ADO_library_FUNCTIONS_EXTENSION_VERSION" {
  description = "the azure devops (tyeesoftware) library variable for FUNCTIONS_EXTENSION_VERSION"
  default     = "~2"
}

variable "ADO_library_FUNCTIONS_WORKER_RUNTIME" {
  description = "the azure devops (tyeesoftware) library variable for FUNCTIONS_WORKER_RUNTIME"
  default     = "dotnet"
}

variable "ADO_library_loginData" {
  description = "the azure devops (tyeesoftware) library variable for loginData"
  default     = ""
}

variable "ADO_library_loginUrl" {
  description = "the azure devops (tyeesoftware) library variable for loginUrl"
  default     = ""
}

variable "ADO_library_TimerRecipient" {
  description = "the azure devops (tyeesoftware) library variable for NotificationRecipient"
  default     = ""
}

variable "ADO_library_NotificationSender" {
  description = "the azure devops (tyeesoftware) library variable for NotificationSender"
  default     = ""
}

variable "ADO_library_slackApi" {
  description = "the azure devops (tyeesoftware) library variable for slackApi"
  default     = ""
}

variable "ADO_library_slackToken" {
  description = "the azure devops (tyeesoftware) library variable for slackToken"
  default     = ""
}

variable "ADO_library_statusUrl" {
  description = "the azure devops (tyeesoftware) library variable for statusUrl"
  default     = ""
}

variable "ADO_library_WEBSITE_NODE_DEFAULT_VERSION" {
  description = "the azure devops (tyeesoftware) library variable for WEBSITE_NODE_DEFAULT_VERSION"
  default     = "8.11.1"
}

variable "ADO_library_AZURE_APP_CLIENT_ID" {
  description = "the azure devops (tyeesoftware) library variable for AZURE_APP_CLIENT_ID"
  default     = ""
}

variable "ADO_library_AZURE_APP_TENANT_ID" {
  description = "the azure devops (tyeesoftware) library variable for AZURE_APP_TENANT_ID"
  default     = ""
}

variable "ADO_library_name" {
  description = "the azure devops (tyeesoftware) library variable for name"
  default     = "status-int-devint"
}

variable "ADO_library_VSTS_ProjectName" {
  description = "the azure devops (tyeesoftware) library variable for VSTS_ProjectName"
  default     = "DevOps"
}

variable "ADO_library_VSTS_PersonalAccessToken" {
  description = "the azure devops (tyeesoftware) library variable for VSTS_PersonalAccessToken"
  default     = "<insert PAT here>"
}

variable "ADO_library_VSTS_InstanceName" {
  description = "the azure devops (tyeesoftware) library variable for VSTS_InstanceName"
  default     = "tyeesoftware"
}

variable "key_vault_name" {
  description = "the name of the keyvault where the secrets are stored"
  default     = ""
}

variable "key_vault_resourcegroup" {
  description = "the resource group for the keyvault...keyvault in order to be accessible via tf needs to be in same subscription"
  default     = ""
}

