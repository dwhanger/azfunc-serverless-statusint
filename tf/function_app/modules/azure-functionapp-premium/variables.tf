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

variable "subnet2_id" {
  description = "Subnet id for the db tier"
  default     = ""
}

variable "ip_to_allow" {
  description = "Subnet id for the db tier"
  default     = ""
}

variable "storage_account_name" {
  description = "Storage Account Name"
  default     = ""
}

variable "storage_account_access_key" {
  description = "Storage Account Access Key"
  default     = ""
}

variable "storage_account_conn_string" {
  description = "Storage Account Connection String"
  default     = ""
}

variable "cosmosdb_endpoint" {
  description = "CososDB endpoint"
  default     = ""
}

variable "cosmosdb_primary_key" {
  description = "CosmosDB access key"
  default     = ""
}

variable "eventgrid_primary_access_key" {
  description = "Eventgrid access key"
  default     = ""
}

variable "eventgrid_endpoint" {
  description = "Eventgrid queue endpoint"
  default     = ""
}

variable "static_website_url" {
  description = "Static website url"
  default     = ""
}

