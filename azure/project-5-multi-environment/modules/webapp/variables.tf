variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string
}

variable "app_name" {
  description = "Application name"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "container_image" {
  description = "Docker image to run"
  type        = string
  default     = "mcr.microsoft.com/oss/nginx/nginx:1.15.5-alpine"
}

variable "cpu" {
  description = "CPU allocation"
  type        = string
  default     = "0.5"
}

variable "memory" {
  description = "Memory allocation"
  type        = string
  default     = "1.5"
}