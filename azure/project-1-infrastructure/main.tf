# This file tells Azure what resources to create

# Connect to Azure
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Create a resource group (like a folder for your resources)
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
}

# Create a simple web app
resource "azurerm_container_group" "webapp" {
  name                = "my-first-webapp"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  os_type            = "Linux"

  container {
    name   = "webapp"
    image  = "mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine"
    cpu    = "0.5"
    memory = "1.5"
    
    ports {
      port     = 80
      protocol = "TCP"
    }
  }
}