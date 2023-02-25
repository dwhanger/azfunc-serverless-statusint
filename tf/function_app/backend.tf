terraform {
  backend "azurerm" {
#devintus
    key                   = "dev-stack"
    container_name        = "status-int"
    storage_account_name  = ""
    access_key            = ""
#qaus
#    key                   = "qaus-stack"
#
#   >> To list all Env variables:
#   >>  Get-ChildItem Env:
#   >>
#
#devintus
#qa
    resource_group_name   = ""
    subscription_id       = ""
    client_id             = ""
    client_secret         = ""
    tenant_id             = ""
  }
}
