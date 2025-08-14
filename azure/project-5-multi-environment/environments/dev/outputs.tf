output "webapp_url" {
  description = "The public URL of the web application in dev environment"
  value       = module.dev_webapp.webapp_url
}

output "webapp_ip" {
  description = "The public IP address of the web application in dev environment"
  value       = module.dev_webapp.webapp_ip
}
