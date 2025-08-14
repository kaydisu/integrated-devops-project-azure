output "webapp_url" {
  description = "The public URL of the web application"
  value       = "http://${azurerm_container_group.webapp.ip_address}"
}

output "webapp_ip" {
  description = "The public IP address of the web application"
  value       = azurerm_container_group.webapp.ip_address
}

output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.main.name
}

output "location" {
  description = "The Azure region where resources are deployed"
  value       = azurerm_resource_group.main.location
} 