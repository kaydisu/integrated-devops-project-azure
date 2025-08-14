# My DevOps Web App with Automated Deployment

A modern Node.js web application demonstrating DevOps best practices with automated testing, containerization, and CI/CD deployment to Azure using GitHub Actions.

## 🎯 What This Project Demonstrates

- **🚀 Automated CI/CD Pipeline** - Tests and deploys on every code push
- **🐳 Containerization** - Docker-based deployment
- **☁️ Cloud Deployment** - Automated deployment to Azure Container Instances
- **🧪 Automated Testing** - Unit tests run on every commit
- **📊 Health Monitoring** - Built-in health checks and metrics
- **🔧 Infrastructure as Code** - Azure resources managed via scripts

## 📋 Prerequisites

Before you begin, ensure you have:

- [Node.js](https://nodejs.org/) (version 18 or higher)
- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- [Git](https://git-scm.com/) for version control
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed
- GitHub account
- Azure account ([free tier](https://azure.microsoft.com/free/) works!)

## 📁 Project Structure

```
my-devops-webapp/
├── app.js                      # Main application file
├── package.json                # Node.js dependencies
├── package-lock.json           # Dependency lock file
├── Dockerfile                  # Container configuration
├── azure_setup.sh              # Azure infrastructure setup script
└── README.md                  # This file
```

## 🚀 Quick Start

### 1. Clone and Setup

```bash
# Clone the repository
git clone https://github.com/yourusername/my-devops-webapp.git
cd my-devops-webapp

# Install dependencies
npm install
```

### 2. Run Locally

```bash
# Start the application
npm start

# The app will be available at:
# http://localhost:3001
```

### 3. Test the Application

```bash
# Run tests
npm test

# Test health endpoint
curl http://localhost:3001/health

# Test metrics endpoint
curl http://localhost:3001/metrics
```

## ☁️ Azure Deployment Setup

### 1. Prepare Azure Environment

```bash
# Make the setup script executable
chmod +x azure_setup.sh

# Run the Azure setup (creates resources and secrets)
./azure_setup.sh
```

This script will:
- Create Azure Resource Group
- Set up Azure Container Registry (ACR)
- Create a Service Principal for GitHub Actions
- Output the required GitHub secrets

### 2. Configure GitHub Secrets

After running the setup script, add these secrets to your GitHub repository:

**Repository Settings → Secrets and variables → Actions → New repository secret**

- `AZURE_CREDENTIALS` - JSON output from setup script
- `AZURE_RESOURCE_GROUP` - Your resource group name
- `ACR_NAME` - Your container registry name
- `ACR_USERNAME` - Container registry username
- `ACR_PASSWORD` - Container registry password

### 3. Deploy via GitHub Actions

```bash
# Commit and push to trigger deployment
git add .
git commit -m "Initial deployment"
git push origin main
```

The CI/CD pipeline will:
1. ✅ Run automated tests
2. 🐳 Build Docker container
3. 📤 Push to Azure Container Registry
4. 🚀 Deploy to Azure Container Instances
5. 🔗 Provide live application URL

## 🔄 CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/deploy.yml`) includes:

### Test Stage
- Install Node.js dependencies
- Run unit tests
- Build and test Docker image

### Deploy Stage (main branch only)
- Login to Azure
- Build and push Docker image to ACR
- Deploy container to Azure Container Instances
- Output live application URL

## 🛠️ Local Development

### Running with Docker

```bash
# Build the Docker image
docker build -t my-webapp .

# Run the container
docker run -p 3001:3001 my-webapp

# Access at http://localhost:3001
```

### Available Endpoints

- `GET /` - Main application page
- `GET /health` - Health check endpoint
- `GET /metrics` - Prometheus metrics endpoint

## 🔧 Troubleshooting

### Common Issues and Solutions

#### ❌ Port 3001 Already in Use

```bash
# Check what's using the port
lsof -ti :3001

# Kill the process
kill -9 <PID>

# Or use a different port
PORT=3002 npm start
```

#### ❌ npm install Fails

```bash
# Clear npm cache
npm cache clean --force

# Remove and reinstall
rm -rf node_modules package-lock.json
npm install
```

#### ❌ Docker Build Fails

```bash
# Ensure Docker is running
docker --version
docker ps

# Try building again
docker build -t my-webapp .
```

#### ❌ Azure Setup Script Fails

**If you get namespace registration errors:**
```bash
az provider register --namespace Microsoft.ContainerInstance
az provider register --namespace Microsoft.ContainerRegistry
```

**If you get permission errors:**
- Ensure you're using a personal Azure subscription
- Try different region: edit `LOCATION="West US"` in azure_setup.sh

#### ❌ GitHub Actions Authentication Fails

1. Re-run the Azure setup script:
   ```bash
   ./azure_setup.sh
   ```

2. Update the `AZURE_CREDENTIALS` secret in GitHub with the new JSON output

#### ❌ Can't Access Deployed App

1. **Wait 3-5 minutes** for Azure to assign the IP address

2. **Check deployment status:**
   ```bash
   az container list --resource-group rg-webapp-deploy --output table
   ```

3. **Get the correct URL:**
   ```bash
   az container show --resource-group rg-webapp-deploy --name <APP_NAME> --query ipAddress.fqdn --output tsv
   ```

4. **Check container logs:**
   ```bash
   az container logs --resource-group rg-webapp-deploy --name <APP_NAME>
   ```

## 📊 Monitoring and Metrics

The application includes:
- **Health checks** at `/health`
- **Prometheus metrics** at `/metrics`
- **Request counting** and uptime tracking
- **Memory usage monitoring**

## 🧹 Cleanup

To avoid ongoing Azure charges:

```bash
# Delete the resource group and all resources
az group delete --name rg-webapp-deploy --yes --no-wait
```

## 🎓 What You've Learned

By completing this project, you've implemented:

- ✅ **CI/CD Pipeline** with GitHub Actions
- ✅ **Containerization** with Docker
- ✅ **Cloud Deployment** to Azure
- ✅ **Automated Testing** in the pipeline
- ✅ **Infrastructure as Code** principles
- ✅ **Monitoring and Observability** basics
- ✅ **DevOps Security** with proper secret management

## 🔗 Next Steps

- Add database integration
- Implement blue-green deployments
- Set up monitoring dashboards with Grafana
- Add security scanning to the pipeline
- Explore Kubernetes orchestration

## 📞 Support

If you encounter issues:

1. Check the troubleshooting section above
2. Review GitHub Actions logs for deployment issues
3. Check Azure portal for resource status
4. Verify all secrets are correctly configured

---

**Happy DevOps! 🚀** 

*This project demonstrates production-ready DevOps practices in a beginner-friendly way.*