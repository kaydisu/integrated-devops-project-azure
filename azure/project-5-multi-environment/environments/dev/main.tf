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

module "dev_webapp" {
  source = "../../modules/webapp"
  
  environment     = "dev"
  app_name       = "myapp"
  container_image = "mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine"
  cpu            = "0.5"  # Small resources for dev
  memory         = "1.0"
}