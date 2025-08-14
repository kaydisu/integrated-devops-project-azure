output "webapp_url" {
  description = "The public URL of the web application in prod environment"
  value       = module.prod_webapp.webapp_url
}

output "webapp_ip" {
  description = "The public IP address of the web application in prod environment"
  value       = module.prod_webapp.webapp_ip
}
