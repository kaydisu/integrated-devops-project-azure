# Reusable web app module

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

resource "azurerm_resource_group" "main" {
  name     = "${var.environment}-${var.app_name}-rg"
  location = var.location
}

resource "azurerm_container_group" "webapp" {
  name                = "${var.environment}-${var.app_name}"
  location           = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ip_address_type     = "Public"
  os_type            = "Linux"

  container {
    name   = var.app_name
    image  = var.container_image
    cpu    = var.cpu
    memory = var.memory
    
    ports {
      port     = 80
      protocol = "TCP"
    }
    
    environment_variables = {
      "ENVIRONMENT" = var.environment
    }
  }
}