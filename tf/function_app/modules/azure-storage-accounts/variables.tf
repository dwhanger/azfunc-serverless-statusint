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

variable "subnet1_id" {
  description = "Subnet id for the web tier"
  default     = ""
}

variable "ip_to_allow" {
  description = "IP address to let in at the firewall"
  default     = ""
}
