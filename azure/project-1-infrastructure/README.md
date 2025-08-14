cd ..
# My First Infrastructure as Code Project

This project creates a simple web application on Azure using Terraform, demonstrating Infrastructure as Code (IaC) principles.

## 🎯 What This Creates

- **Resource Group** - A logical container for your Azure resources
- **Container Instance** - Runs a simple web application in a Docker container
- **Public IP Address** - Makes your application accessible from the internet
- **Network Security** - Basic firewall rules for web traffic

## 📋 Prerequisites

Before starting, ensure you have:

- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- [Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli) installed
- An Azure account ([free tier](https://azure.microsoft.com/free/) works perfectly!)
- Basic knowledge of command line operations

## 📁 Project Structure

```
my-first-infrastructure/
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── terraform.tfvars     # Variable values (customize this!)
├── outputs.tf           # Output definitions
└── README.md           # This file
```

## 🚀 Step-by-Step Deployment

### 1. Initial Setup

```bash
# Clone or download this project
git clone <repository-url>
cd my-first-infrastructure

# Login to Azure
az login
# Follow the browser prompts to complete authentication
```

### 2. Customize Your Deployment

Edit `terraform.tfvars` to personalize your deployment:

```hcl
# Example terraform.tfvars
resource_group_name = "rg-yourname-devops"
location           = "East US"
container_name     = "my-webapp"
```

### 3. Deploy Infrastructure

```bash
# Initialize Terraform (download providers)
terraform init

# Preview what will be created
terraform plan

# Create the infrastructure
terraform apply
# Type 'yes' when prompted
```

### 4. Access Your Application

After deployment completes:

```bash
# Get your application's public IP
terraform output container_ip

# Open in browser
# http://YOUR_IP_ADDRESS
```

## 🧹 Cleanup

To avoid ongoing charges, destroy resources when done:

```bash
terraform destroy
# Type 'yes' when prompted
```

## 🔧 Troubleshooting

### Common Issues and Solutions

#### ❌ "Command not found" Errors

```bash
az: command not found
terraform: command not found
```

**Solution:**
- Reinstall Azure CLI and Terraform
- Restart your terminal
- Verify installation: `az --version` and `terraform --version`

#### ❌ Docker Registry Error (409 Conflict)

```bash
RegistryErrorResponse: An error response is received from the docker registry
```

**Solution:**
- Wait 10-15 minutes and retry `terraform apply`
- This is a temporary Docker Hub rate limit issue

#### ❌ Resource Group Already Exists

```bash
Error: A resource group with the name 'rg-john-devops' already exists
```

**Solution:**
- Change `resource_group_name` in `terraform.tfvars` to something unique
- Re-run `terraform apply`

#### ❌ Authentication Failed

**Solution:**
```bash
az login
az account show  # Verify you're logged in
terraform apply
```

#### ❌ Can't Access the Website

**Troubleshooting steps:**

1. **Check container status:**
   ```bash
   az container show --resource-group <your-rg-name> --name <your-container-name> --query "instanceView.state"
   ```

2. **Get current IP:**
   ```bash
   terraform output container_ip
   ```

3. **Check container logs:**
   ```bash
   az container logs --resource-group <your-rg-name> --name <your-container-name>
   ```

#### ❌ Insufficient Permissions

**Solution:**
- Use a personal Azure subscription if possible
- Try a different region in `terraform.tfvars`:
  ```hcl
  location = "West US"
  ```

## 📚 What You've Learned

By completing this project, you've:

- ✅ Used Infrastructure as Code (Terraform)
- ✅ Created cloud resources programmatically
- ✅ Deployed a containerized application
- ✅ Managed cloud infrastructure lifecycle
- ✅ Practiced DevOps fundamentals

## 🔗 Next Steps

- Explore more Terraform providers
- Add monitoring and logging
- Implement CI/CD pipelines
- Learn about container orchestration (Kubernetes)

## 📞 Support

If you encounter issues not covered here:
1. Check the [Terraform Azure Provider docs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
2. Review [Azure Container Instances documentation](https://docs.microsoft.com/en-us/azure/container-instances/)
3. Search existing issues on the project repository

---

**Happy Infrastructure Building! 🎉**