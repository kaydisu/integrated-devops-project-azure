# This file defines the settings you can change

variable "resource_group_name" {
  description = "Name for your resource group"
  type        = string
  default     = ""
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}