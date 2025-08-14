# DevOps Portfolio Projects - Azure Implementation Guide

This repository contains 5 beginner-to-intermediate DevOps projects designed to help you build a job-winning portfolio. Each project is organized in its own folder with step-by-step implementation instructions.

> ⚠️ **Note:** For this project, I'll be demonstrating using **Azure Cloud**. However, if you're an **AWS** user, you can find the corresponding code files for AWS in the repository and follow along with those instead by using the implementation steps in the README.md files under each AWS project folder.

---

## ✅ Project 1: Infrastructure as Code with Terraform

**Tools:** Terraform, Azure CLI, Azure Container Instances

### Steps:

1. Install Azure CLI and Terraform
2. Create a free Azure account
3. Login to Azure using `az login`
4. Clone this repo and go to `project-1-infrastructure`
5. Copy and edit `terraform.tfvars` with your config (e.g., resource group name and location)
6. Run `terraform init` to initialize
7. Run `terraform plan` to preview
8. Run `terraform apply` to deploy
9. Get public IP from `terraform output` and test in browser or via `curl`
10. Destroy resources using `terraform destroy`

---

## ✅ Project 2: CI/CD Pipeline with GitHub Actions

**Tools:** GitHub Actions, Node.js, Docker, Azure Container Registry

### Steps:

1. Install Node.js and Docker Desktop
2. Clone this repo and go to `project-2-cicd-pipeline`
3. Run `npm install` and `npm start` to test locally
4. Build Docker image with `docker build -t my-webapp .`
5. Push code to GitHub repository
6. Run `azure_setup.sh` to create ACR and service principal
7. Add required secrets to GitHub Actions: `AZURE_CREDENTIALS`, `ACR_NAME`, etc.
8. Trigger workflow by pushing code to main branch
9. Get public URL from GitHub Actions or Azure CLI
10. Modify and push again to see auto-deployment
11. Clean up Azure resources with `az group delete`

---

## ✅ Project 3: Container Orchestration with Kubernetes

**Tools:** Kubernetes (Docker Desktop or Minikube), kubectl

### Steps:

1. Enable Kubernetes via Docker Desktop or install Minikube
2. Install `kubectl`
3. Build Docker image for the app
4. Navigate to `project-3-kubernetes` and apply `k8s/app.yaml`
5. Wait for pods to be ready
6. Access the app via `minikube service`, port-forwarding, or localhost
7. Test scaling, self-healing by deleting pods
8. Clean up with `kubectl delete -f k8s/app.yaml`

---

## ✅ Project 4: Monitoring with Prometheus and Grafana

**Tools:** Docker Compose, Prometheus, Grafana

### Steps:

1. Navigate to `project-4-monitoring`
2. Run `docker-compose up -d` to start monitoring stack
3. Visit Prometheus at `http://localhost:9090`
4. Visit Grafana at `http://localhost:3000` (admin/admin)
5. Add Prometheus as data source in Grafana
6. Create basic dashboards or import from grafana.com (e.g., ID 1860)
7. Monitor Node.js app from project 2
8. Set up alerts in Grafana
9. Stop monitoring stack using `docker-compose down`

---

## ✅ Project 5: Multi-Environment Infrastructure

**Tools:** Terraform Modules, Azure CLI

### Steps:

1. Navigate to `project-5-multi-environment`
2. Explore the folder structure: `modules/` and `environments/dev` & `environments/prod`
3. Go to `environments/dev` and run `terraform init` → `apply`
4. Add outputs to module to expose public IP/URL if not already present
5. Access the app via browser or `curl`
6. Repeat same steps for `environments/prod`
7. Verify isolation by changing container image in dev only
8. Practice shared updates by adding variables to the module
9. Destroy both environments using `terraform destroy`

---

## ✅ Final Notes

Each project folder includes its own `README.md` with tailored instructions and configs.

Be sure to:

* Customize the `.tfvars`, `.yml`, or YAML files to fit your use case

Happy building! 🚀
