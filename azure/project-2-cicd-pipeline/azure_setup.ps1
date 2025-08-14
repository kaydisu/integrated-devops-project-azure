# Check Azure login status
Write-Host "Checking Azure login status..."
try {
    $account = az account show --output json | ConvertFrom-Json
    Write-Host "✅ Already logged into Azure as $($account.user.name)"
}
catch {
    Write-Host "You are not logged in. Opening browser to login..."
    az login
    if ($LASTEXITCODE -ne 0) {
        Write-Error "❌ Azure login failed. Exiting."
        exit 1
    }
}

# Variables
$RESOURCE_GROUP_NAME = "rg-webapp-deploy"

# Create a numeric timestamp suffix without dots
$TIMESTAMP = [int](Get-Date -UFormat %s)
$TIMESTAMP_SUFFIX = $TIMESTAMP.ToString().Substring($TIMESTAMP.ToString().Length - 6)

$ACR_NAME = ("acrwebapp" + $TIMESTAMP_SUFFIX).ToLower()
$LOCATION = "canadacentral"
$SP_NAME = "github-actions-webapp"

Write-Host "Setting up Azure resources..."
Write-Host "Resource Group: $RESOURCE_GROUP_NAME"
Write-Host "ACR Name: $ACR_NAME"
Write-Host "Location: $LOCATION"

# Create resource group
Write-Host "Creating resource group..."
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION | Out-Null

# Create Azure Container Registry
Write-Host "Creating Azure Container Registry..."
az acr create `
  --resource-group $RESOURCE_GROUP_NAME `
  --name $ACR_NAME `
  --sku Basic `
  --admin-enabled | Out-Null

# Get ACR credentials
Write-Host "Getting ACR credentials..."
$ACR_USERNAME = az acr credential show --name $ACR_NAME --query username --output tsv
$ACR_PASSWORD = az acr credential show --name $ACR_NAME --query passwords[0].value --output tsv

# Get current subscription ID
$SUBSCRIPTION_ID = az account show --query id --output tsv

# Create service principal for GitHub Actions
Write-Host "Creating service principal..."
$AZURE_CREDENTIALS = az ad sp create-for-rbac `
  --name $SP_NAME `
  --role contributor `
  --scopes "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP_NAME" `
  --sdk-auth

Write-Host ""
Write-Host "=========================================="
Write-Host "SETUP COMPLETE! 🚀"
Write-Host "=========================================="
Write-Host ""
Write-Host "GitHub Secrets to create:"
Write-Host ""
Write-Host "AZURE_CREDENTIALS:"
Write-Host $AZURE_CREDENTIALS
Write-Host ""
Write-Host "ACR_NAME: $ACR_NAME"
Write-Host ""
Write-Host "ACR_USERNAME: $ACR_USERNAME"
Write-Host ""
Write-Host "ACR_PASSWORD: $ACR_PASSWORD"
Write-Host ""
Write-Host "AZURE_RESOURCE_GROUP: $RESOURCE_GROUP_NAME"
Write-Host ""
Write-Host "=========================================="
Write-Host ""
Write-Host "Next steps:"
Write-Host "1. Copy the above values to your GitHub repository secrets"
Write-Host "2. Make sure your project-2 directory has a Dockerfile"
Write-Host "3. Push your code to trigger the deployment"
Write-Host ""
Write-Host "To clean up later, run:"
Write-Host "az group delete --name $RESOURCE_GROUP_NAME --yes --no-wait"

Read-Host "Press Enter to exit..."

##    To clean up later, run: ###
#   az group delete --name rg-webapp-deploy --yes --no-wait