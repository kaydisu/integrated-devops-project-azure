# Multi-Environment Infrastructure with Terraform

A comprehensive guide to creating reusable infrastructure modules and managing separate development and production environments using Infrastructure as Code (IaC) best practices.

## 🎯 What This Project Demonstrates

- **📦 Terraform Modules** - Creating reusable infrastructure components
- **🔄 Environment Management** - Separate dev and production configurations
- **🏗️ DRY Principles** - Don't Repeat Yourself in infrastructure code
- **⚖️ Environment Scaling** - Different resource sizes for different environments
- **🔒 Security Best Practices** - Environment-specific security configurations
- **📊 Cost Optimization** - Resource sizing based on environment needs

## 📋 Prerequisites

Before you begin, ensure you have:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) (version 1.0+)
- An Azure account ([free tier](https://azure.microsoft.com/free/) works!)
- Completion of Project 1 (basic Terraform knowledge)
- Understanding of infrastructure concepts

## 📁 Project Structure

```
project-5-multi-environment/
├── modules/
│   └── webapp/                    # Reusable webapp module
│       ├── main.tf               # Core infrastructure resources
│       ├── variables.tf          # Configurable parameters
│       ├── outputs.tf            # Module outputs
├── environments/
│   ├── dev/                      # Development environment
│   │   ├── main.tf              # Dev-specific configuration
│   │   ├── outputs.tf         # Dev outputs
│   └── prod/                     # Production environment
│       ├── main.tf              # Prod-specific configuration
│       ├── outputs.tf         # Prod outputs
├── README.md                     # This file
```

## 🏗️ Architecture Overview

### Why This Structure?

- **🔄 Reusability** - Write infrastructure code once, use it everywhere
- **🎯 Consistency** - Same base configuration across environments
- **⚙️ Flexibility** - Environment-specific customizations
- **🛡️ Safety** - Isolated environments prevent cross-contamination
- **📈 Scalability** - Easy to add new environments (staging, testing, etc.)

### Environment Differences

| Feature | Development | Production |
|---------|------------|------------|
| **CPU** | 0.5 cores | 2.0 cores |
| **Memory** | 1.0 GB | 4.0 GB |
| **Replicas** | 1 instance | 3 instances |
| **Monitoring** | Basic | Advanced |
| **Cost** | ~$20/month | ~$150/month |

## 🚀 Step-by-Step Deployment

### 1. Initial Setup

```bash
# Clone or navigate to the project directory
cd project-5-multi-environment

# Login to Azure
az login

# Verify your subscription
az account show

# Set your preferred subscription (if needed)
az account set --subscription "Your Subscription Name"
```

### 2. Deploy Development Environment

```bash
# Navigate to dev environment
cd environments/dev

# Initialize Terraform
terraform init

# Review the execution plan
terraform plan

# Deploy the development environment
terraform apply
# Type 'yes' when prompted

# Get the development URL
terraform output webapp_url
```

### 3. Test Development Environment

```bash
# Test the application
curl $(terraform output -raw webapp_url)

# Check application health
curl $(terraform output -raw webapp_url)/health

# View in browser
echo "Development app: $(terraform output -raw webapp_url)"
```

### 4. Deploy Production Environment

```bash
# Navigate to production environment
cd ../prod

# Initialize Terraform
terraform init

# Review the production plan (notice the differences!)
terraform plan

# Deploy production environment
terraform apply
# Type 'yes' when prompted

# Get the production URL
terraform output webapp_url
```

### 5. Compare Environments

```bash
# Compare resource configurations
cd ../dev
terraform show | grep -A 5 "azurerm_container_group"

cd ../prod
terraform show | grep -A 5 "azurerm_container_group"
```

## ⚙️ Module Configuration

### webapp Module (modules/webapp/main.tf)

```hcl
# Resource Group
resource "azurerm_resource_group" "webapp" {
  name     = "${var.environment}-${var.app_name}-rg"
  location = var.location
  
  tags = {
    Environment = var.environment
    Project     = var.app_name
    ManagedBy   = "Terraform"
  }
}

# Container Group
resource "azurerm_container_group" "webapp" {
  name                = "${var.environment}-${var.app_name}"
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  ip_address_type     = "Public"
  os_type             = "Linux"

  container {
    name   = var.app_name
    image  = var.container_image
    cpu    = var.cpu_cores
    memory = var.memory_gb

    ports {
      port     = var.container_port
      protocol = "TCP"
    }

    environment_variables = var.environment_variables
  }

  tags = {
    Environment = var.environment
    Project     = var.app_name
  }
}
```

### Environment-Specific Configurations

#### Development (environments/dev/terraform.tfvars)
```hcl
app_name         = "mywebapp"
environment      = "dev"
location         = "East US"
container_image  = "nginx:latest"
cpu_cores        = "0.5"
memory_gb        = "1.0"
container_port   = 80

environment_variables = {
  "ENV" = "development"
  "DEBUG" = "true"
}
```

#### Production (environments/prod/terraform.tfvars)
```hcl
app_name         = "mywebapp"
environment      = "prod"
location         = "East US"
container_image  = "nginx:latest"
cpu_cores        = "2.0"
memory_gb        = "4.0"
container_port   = 80

environment_variables = {
  "ENV" = "production"
  "DEBUG" = "false"
}
```

## 🔧 Advanced Features

### Environment-Specific Networking

```hcl
# Production gets additional security
dynamic "network_profile" {
  for_each = var.environment == "prod" ? [1] : []
  content {
    id = azurerm_network_profile.webapp[0].id
  }
}
```

### Conditional Resources

```hcl
# Monitoring only in production
resource "azurerm_application_insights" "webapp" {
  count               = var.environment == "prod" ? 1 : 0
  name                = "${var.environment}-${var.app_name}-insights"
  location            = azurerm_resource_group.webapp.location
  resource_group_name = azurerm_resource_group.webapp.name
  application_type    = "web"
}
```

## 🛠️ Troubleshooting Guide

### ❌ Module Not Found Error

**Error**: `Module not found: ./modules/webapp`

**Solutions**:
```bash
# Check current directory
pwd
# Should be in: /path/to/project-5-multi-environment/environments/dev

# Verify module exists
ls ../../modules/webapp/
# Should show: main.tf, variables.tf, outputs.tf
```

### ❌ Resource Already Exists

**Error**: `A resource group with the name 'dev-myapp-rg' already exists`

**Solutions**:
```bash
# List existing resource groups
az group list --output table

# Delete existing resource group
az group delete --name dev-myapp-rg --yes --no-wait

# Or change the app name in terraform.tfvars
app_name = "myapp-v2"
```

### ❌ No Output Values

**Problem**: `terraform output` returns nothing

**Solutions**:
```bash
# Check outputs are defined in module
cat ../../modules/webapp/outputs.tf

# Use Azure CLI as alternative
az container show \
  --resource-group dev-myapp-rg \
  --name dev-myapp \
  --query ipAddress.ip \
  --output tsv
```

### ❌ Environment Differences Not Working

**Debug steps**:
```bash
# Compare configurations
cd environments/dev
terraform show | grep -A 10 container

cd ../prod
terraform show | grep -A 10 container

# Check actual Azure resources
az container show \
  --resource-group dev-myapp-rg \
  --name dev-myapp \
  --query "containers[0].resources"
```

### ❌ Terraform Init Fails

**Solutions**:
```bash
# Delete terraform cache
rm -rf .terraform .terraform.lock.hcl

# Re-initialize
terraform init

# Verify module paths
ls ../../modules/webapp/main.tf
```

### ❌ Container Won't Start

**Check container status**:
```bash
# View container events
az container show \
  --resource-group dev-myapp-rg \
  --name dev-myapp \
  --query "instanceView.events"

# Check container logs
az container logs \
  --resource-group dev-myapp-rg \
  --name dev-myapp
```

## 🔄 Management Operations

### Updating Environments

```bash
# Update development
cd environments/dev
terraform plan
terraform apply

# Update production (with approval)
cd ../prod
terraform plan
terraform apply
```

### Scaling Resources

```bash
# Edit terraform.tfvars
cpu_cores = "1.0"    # Increase CPU
memory_gb = "2.0"    # Increase memory

# Apply changes
terraform apply
```

### Adding New Environments

```bash
# Create staging environment
mkdir environments/staging
cp environments/dev/* environments/staging/

# Edit staging/terraform.tfvars
environment = "staging"
cpu_cores   = "1.0"
memory_gb   = "2.0"
```

## 🧹 Cleanup

### Destroy Specific Environment

```bash
# Destroy development
cd environments/dev
terraform destroy

# Destroy production
cd environments/prod
terraform destroy
```

### Destroy All Environments

```bash
# Script to destroy all
for env in dev prod; do
  cd environments/$env
  terraform destroy -auto-approve
  cd ../..
done
```

## 🎓 What You've Learned

By completing this project, you've mastered:

- ✅ **Terraform Modules** - Creating reusable infrastructure components
- ✅ **Environment Management** - Separating dev and production
- ✅ **Configuration Management** - Environment-specific variables
- ✅ **Infrastructure Scaling** - Different resource sizes per environment
- ✅ **Code Organization** - Clean, maintainable infrastructure code
- ✅ **Best Practices** - DRY principles and security considerations
- ✅ **Operations** - Deploying and managing multiple environments
- ✅ **Cost Optimization** - Right-sizing resources for each environment

## 🔗 Next Steps

- **CI/CD Integration**: Automate deployments with GitHub Actions
- **State Management**: Use remote state with Azure Storage
- **Advanced Modules**: Create modules for databases, networking, monitoring
- **Multi-Cloud**: Adapt modules for AWS or Google Cloud
- **Governance**: Implement Azure Policy and resource tags
- **Secret Management**: Integrate with Azure Key Vault
- **Disaster Recovery**: Implement cross-region deployments

## 📚 Best Practices Learned

### Module Design
- Keep modules focused and single-purpose
- Use meaningful variable names and descriptions
- Provide comprehensive outputs
- Include examples and documentation

### Environment Management
- Use consistent naming conventions
- Implement proper tagging strategies
- Separate state files for each environment
- Use environment-specific variable files

### Security
- Apply principle of least privilege
- Use managed identities where possible
- Implement environment-specific security rules
- Regular security reviews and updates

---

**Congratulations! 🎉** 

*You've built a production-ready, multi-environment infrastructure setup! This pattern is used by organizations worldwide to manage their cloud infrastructure.*