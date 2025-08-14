output "webapp_url" {
  description = "Public URL of the web application"
  value       = "http://${azurerm_container_group.webapp.ip_address}"
}

output "webapp_ip" {
  description = "Public IP address of the web application"
  value       = azurerm_container_group.webapp.ip_address
}