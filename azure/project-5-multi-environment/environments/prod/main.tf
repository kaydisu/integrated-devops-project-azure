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

module "prod_webapp" {
  source = "../../modules/webapp"
  
  environment     = "prod"
  app_name       = "myapp"
  container_image = "mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine"
  cpu            = "1.0"  # More resources for prod
  memory         = "2.0"
}