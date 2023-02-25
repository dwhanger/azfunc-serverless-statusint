# Input variable definitions
#
variable "tags" {
  description = "Tags to set on the resource"
  type        = map(string)
  default     = {}
}

/*
variable "resgroup_main" {
  description = "The main resource group object"
  type	  = list(string)
  default     = []
}
*/

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
