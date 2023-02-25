#
# Enable some extensions...
#
resource "null_resource" "add_az_extention_for_azure-devops" {
  #
  #az extension add --name azure-devops
  #
  provisioner "local-exec" {
    command = "az extension add --name azure-devops"
  }
}

locals {
  azdevops_library_payload = <<EOF
{
  'variables': {
     'ADAL_ACCESS_TOKEN': {'value': '${var.ADO_library_ADAL_ACCESS_TOKEN}'},
     'AppInsightsApiKey': {'value': '${var.application_insights_api_key_full_permissions_api_key}'},
     'AppInsightsApp': {'value': '${var.application_insights_func_app_app_id}'},
     'appsetting.APPINSIGHTS_INSTRUMENTATIONKEY': {'value': '${var.application_insights_func_app_instrumentation_key}'},
     'appsetting.AzureWebJobsStorage': {'value': '${var.func_app_sa_connection_string}'},
     'appsetting.COSMOS_DB_CONNECTION_STRING': {'value': 'AccountEndpoint=${var.cosmosdb_endpoint};AccountKey=${var.cosmosdb_primary_key};'},
     'appsetting.EVENTGRID_SAS_KEY': {'value': '${var.eventgrid_primary_access_key}'},
     'appsetting.EVENTGRID_TOPIC_ENDPOINT': {'value': '${var.eventgrid_endpoint}'},
     'appsetting.WEBSITE_CONTENTAZUREFILECONNECTIONSTRING': {'value': '${var.func_app_sa_connection_string}'},
     'appsetting.WEBSITE_CONTENTSHARE': {'value': '${var.func_app_sa_name}'},
     'appsetting.AZURE_APP_ISSUER': {'value': '${var.ADO_library_AZURE_APP_ISSUER}'},
     'appsetting.AZURE_APP_TENANT_ID': {'value': '${var.ADO_library_appsettings_AZURE_APP_TENANT_ID}'},
     'appsetting.AzureWebJobsDashboard': {'value': '${var.func_app_sa_connection_string}'},
     'appsetting.AzureWebJobsDisableHomepage': {'value': 'TRUE'},
     'appsetting.AzureWebJobsSendGridApiKey': {'value': '${var.ADO_library_AzureWebJobsSendGridApiKey}'},
     'appsetting.dynatraceApi': {'value': '${var.ADO_library_dynatraceApi}'},
     'appsetting.dynatraceToken': {'value': '${var.ADO_library_dynatraceToken}'},
     'appsetting.FUNCTIONS_EXTENSION_VERSION': {'value': '${var.ADO_library_FUNCTIONS_EXTENSION_VERSION}'},
     'appsetting.FUNCTIONS_WORKER_RUNTIME': {'value': '${var.ADO_library_FUNCTIONS_WORKER_RUNTIME}'},
     'appsetting.loginData': {'value': '${var.ADO_library_loginData}'},
     'appsetting.loginUrl': {'value': '${var.ADO_library_loginUrl}'},
     'appsetting.NotificationSender': {'value': '${var.ADO_library_NotificationSender}'},
     'appsetting.slackApi': {'value': '${var.ADO_library_slackApi}'},
     'appsetting.slackToken': {'value': '${var.ADO_library_slackToken}'},
     'appsetting.statusUrl': {'value': '${var.ADO_library_statusUrl}'},
     'appsetting.TimerRecipient': {'value': '${var.ADO_library_TimerRecipient}'},
     'appsetting.VSTS_InstanceName': {'value': '${var.ADO_library_VSTS_InstanceName}'},
     'appsetting.VSTS_PersonalAccessToken': {'value': '${trimspace(var.vsts_pat_keyvault_secret)}'},
     'appsetting.VSTS_ProjectName': {'value': '${var.ADO_library_VSTS_ProjectName}'},
     'appsetting.WEBSITE_NODE_DEFAULT_VERSION': {'value': '${var.ADO_library_WEBSITE_NODE_DEFAULT_VERSION}'},
     'appsetting.xxxWEBSITE_DNS_ALT_SERVER': {'value': '${var.dns_alt_server}'},
     'appsetting.xxxWEBSITE_DNS_SERVER': {'value': '${var.dns_server}'},
     'AZURE_APP_CLIENT_ID': {'value': '${var.ADO_library_AZURE_APP_CLIENT_ID}'},
     'AZURE_APP_TENANT_ID': {'value': '${var.ADO_library_AZURE_APP_TENANT_ID}'},
     'AZURE_APP_LOGOUT_REDIRECT_URI': {'value': '${trimspace(var.static_website_url)}'},
     'AZURE_APP_REDIRECT_URI': {'value': '${trimspace(var.static_website_url)}'},
     'DELETE_FORM_ENTRY': {'value': 'https://${var.func_app_default_hostname}/api/epstatusconfigdelete'},
     'GET_CONFIG_ENTRY': {'value': 'https://${var.func_app_default_hostname}/api/epstatusconfig/'},
     'GET_GENERAL_CONFIG': {'value': 'https://${var.func_app_default_hostname}/api/generalconfig/get'},
     'GET_MAIN_ENTRY': {'value': 'https://${var.func_app_default_hostname}/api/epstatuscheck'},
     'GET_STATUS_HISTORY': {'value': 'https://${var.func_app_default_hostname}/api/epstatushistory'},
     'PATCH_FORM_ENTRY': {'value': 'https://${var.func_app_default_hostname}/api/epstatusconfigupdate/'},
     'POST_FORM_ENTRY': {'value': 'https://${var.func_app_default_hostname}/api/epstatusconfigcreate'},
     'UPDATE_GENERAL_CONFIG': {'value': 'https://${var.func_app_default_hostname}/api/generalconfig/update'},
     'URL_FOR_THE_BACKEND_REST_API': {'value': 'https://${var.func_app_default_hostname}/api/epstatuscheck'}
  },
  'type': 'Vsts',
  'name': '${var.ADO_library_name}',
  'description': 'The generated library variable group'
}
EOF

}

#
# A handful of constants...
#
locals {
  str_empty = ""
}

locals {
  str_doublequote = "__quote__"
}

locals {
  str_backslash = "\\"
}

locals {
  str_newline = "\n"
}

locals {
  curl_command_for_parm_config = <<EOF
"curl.exe -H Content-Type:application/json -u ${var.vsts_username_keyvault_secret}:${trimspace(var.vsts_pat_keyvault_secret)} ${var.ADO_organization_url}/${var.ADO_project}/_apis/distributedtask/variablegroups/${var.ADO_library_groupid}?api-version=5.0-preview.1 -X PUT -d ${local.str_doublequote}${local.azdevops_library_payload}${local.str_doublequote}"
EOF

}

# 
# Set all of the connection strings and keys in azure devops for the deployment purposes...
# 
resource "null_resource" "update_the_library_group_variables_for_all_just_generated_ids_connection_strings_and_apikeys" {
  depends_on = [null_resource.add_az_extention_for_azure-devops]

  #
  # echo our command out to a file where we can do searches and replaces on quotes without Terraform getting in the way...
  #
  provisioner "local-exec" {
    working_dir = "${path.module}\\..\\.."
    command = "echo ${replace(
      local.curl_command_for_parm_config,
      local.str_newline,
      local.str_empty,
    )} > update_devops_variables.txt"
  }

  #
  # Do string replacement on __quote__ and replace with " from a powershell script...
  #
  provisioner "local-exec" {
    #
    # Can't do the following....and the escape sequence in the single quotes of \"" is the only thing which works from the powershell command line...
    #   command = "powershell -Command \"(gc ${path.module}/update_devops_variables.txt) -replace '__quote__', '\""' | Out-File -encoding ASCII ${path.module}\\update_devops_variables.bat\""
    #
    # ....instead shell out and execute the batch file...
    #
    working_dir = "${path.module}\\..\\.."
    command = "do_powershell_search_and_replace.bat"
  }

  #
  # Update library variable group with all generated ids....
  #
  # PUT https://dev.azure.com/{organization}/{project}/_apis/distributedtask/variablegroups/{groupId}?api-version=5.0-preview.1
  #
  provisioner "local-exec" {
    working_dir = "${path.module}\\..\\.."
    command = "update_devops_variables.bat"
  }
}

