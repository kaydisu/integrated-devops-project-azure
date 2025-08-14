# Running My Web App on Kubernetes

A comprehensive guide to deploying and managing a Node.js web application on Kubernetes, demonstrating container orchestration, scaling, and reliability best practices.

## 🎯 What This Project Demonstrates

- **🚀 Container Orchestration** - Kubernetes management of containerized applications
- **⚖️ Load Balancing** - Automatic traffic distribution across multiple app instances
- **🔄 Auto-scaling** - Horizontal Pod Autoscaler for dynamic scaling
- **💪 High Availability** - Multiple replicas with automatic restart on failure
- **🌐 Service Discovery** - Kubernetes networking and service exposure
- **📊 Resource Management** - CPU and memory limits/requests

## 📋 Prerequisites

Before you begin, ensure you have:

- [Docker Desktop](https://www.docker.com/products/docker-desktop) with Kubernetes enabled
  - **OR** [Minikube](https://minikube.sigs.k8s.io/docs/start/) installed
- [kubectl](https://kubernetes.io/docs/tasks/tools/) command line tool
- Your web application from the previous CI/CD project
- Basic understanding of containers and Docker

## 📁 Project Structure

```
kubernetes-webapp/
├── k8s/
│   ├── app.yaml               # Kubernetes deployment configuration        
├── app.js                     # Your Node.js application
├── package.json               # Dependencies
├── Dockerfile                 # Container configuration
└── README.md                  # This file
```

## 🚀 Step-by-Step Deployment

### 1. Setup Kubernetes Environment

#### Option A: Docker Desktop
1. Open Docker Desktop
2. Go to **Settings → Kubernetes**
3. Check **"Enable Kubernetes"**
4. Click **"Apply & Restart"**
5. Wait for the green Kubernetes indicator

#### Option B: Minikube
```bash
# Start Minikube with adequate resources
minikube start --memory=4096 --cpus=2

# Verify cluster is running
kubectl cluster-info
```

### 2. Verify Kubernetes Setup

```bash
# Check cluster status
kubectl get nodes

# Verify you can connect
kubectl get pods --all-namespaces
```

### 3. Build Your Application Image

```bash
# For Docker Desktop users
docker build -t my-webapp:latest .

# For Minikube users (build inside Minikube's Docker environment)
eval $(minikube docker-env)
docker build -t my-webapp:latest .

# Verify the image was built
docker images | grep my-webapp
```

### 4. Deploy to Kubernetes

```bash
# Apply all Kubernetes configurations
kubectl apply -f k8s/

# Verify deployment
kubectl get deployments
kubectl get pods
kubectl get services
```

### 5. Access Your Application

#### For Docker Desktop:
```bash
# Check service status
kubectl get services my-webapp-service

# Access via LoadBalancer (may take 2-3 minutes)
# Look for EXTERNAL-IP (usually localhost)
```

#### For Minikube:
```bash
# Get the service URL
minikube service my-webapp-service --url

# Or use port forwarding
kubectl port-forward service/my-webapp-service 8080:8080
# Then visit: http://localhost:8080
```

### 6. Verify Your Deployment

```bash
# Check pod status
kubectl get pods -l app=my-webapp

# View pod logs
kubectl logs -l app=my-webapp

# Test the health endpoint
curl http://localhost:8080/health

# Check resource usage
kubectl top pods
```

## 📊 Monitoring Your Application

### View Application Metrics
```bash
# Get detailed pod information
kubectl describe pods -l app=my-webapp

# Monitor resource usage
kubectl top pods
kubectl top nodes

# Check events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Test Auto-scaling
```bash
# Create load to test HPA
kubectl run -i --tty load-generator --rm --image=busybox --restart=Never -- /bin/sh

# Inside the container, run:
while true; do wget -q -O- http://my-webapp-service:8080/; done

# In another terminal, watch scaling:
kubectl get hpa my-webapp-hpa --watch
```

## 🔧 Kubernetes Configuration Details

### Deployment Features
- **3 replicas** for high availability
- **Resource limits** (500m CPU, 512Mi memory)
- **Resource requests** (200m CPU, 256Mi memory)
- **Rolling update strategy** for zero-downtime deployments

### Service Configuration
- **LoadBalancer type** for external access
- **Port 8080** mapped to container port 3001
- **Automatic load balancing** across all healthy pods

### Auto-scaling Setup
- **Minimum 2 pods**, **maximum 10 pods**
- **Scales at 70% CPU utilization**
- **Metrics server** required for monitoring

## 🛠️ Troubleshooting Guide

### ❌ Pods Stuck in Pending State

**Check node resources:**
```bash
kubectl describe nodes
kubectl get events --sort-by=.metadata.creationTimestamp
```

**For Minikube - increase resources:**
```bash
minikube stop
minikube config set memory 4096
minikube config set cpus 2
minikube start
```

### ❌ Image Pull Failed

**Error:** `Failed to pull image "my-webapp:latest"`

**Solution:**
```bash
# Verify image exists
docker images | grep my-webapp

# For Minikube, rebuild in correct environment
eval $(minikube docker-env)
docker build -t my-webapp:latest .

# Ensure imagePullPolicy is set to Never in deployment.yaml
```

### ❌ Pod CrashLoopBackOff

**Check pod logs:**
```bash
kubectl logs -l app=my-webapp
kubectl describe pods -l app=my-webapp
```

**Common causes:**
- Wrong port configuration (should be 3001)
- Missing dependencies in Docker image
- Application errors

**Test locally:**
```bash
docker run -p 3001:3001 my-webapp:latest
```

### ❌ Can't Access Service

**For LoadBalancer services showing `<pending>` EXTERNAL-IP:**

**Docker Desktop:**
```bash
# Wait 2-3 minutes, then restart Docker Desktop
# Use port forwarding as alternative:
kubectl port-forward service/my-webapp-service 8080:8080
```

**Minikube:**
```bash
# Get service URL
minikube service my-webapp-service --url
```

### ❌ WSL Port Access Issues (Windows)

**Solution 1 - Port forwarding:**
```bash
kubectl port-forward service/my-webapp-service 8080:8080
# Access: http://localhost:8080
```

**Solution 2 - Patch service port:**
```bash
kubectl patch service my-webapp-service -p '{"spec":{"ports":[{"port":8080,"targetPort":3001}]}}'
```

### ❌ kubectl Connection Refused

**Check cluster status:**
```bash
kubectl config current-context
kubectl cluster-info
```

**For Docker Desktop:**
- Ensure Kubernetes is enabled in settings
- Restart Docker Desktop

**For Minikube:**
```bash
minikube status
minikube start
```

## 🧹 Cleanup

### Remove Application
```bash
# Delete all resources
kubectl delete -f k8s/

# Verify deletion
kubectl get pods
kubectl get services
```

### Stop Cluster (Minikube)
```bash
minikube stop
# Or completely remove: minikube delete
```

## 🎓 What You've Learned

By completing this project, you've mastered:

- ✅ **Kubernetes Fundamentals** - Pods, Deployments, Services
- ✅ **Container Orchestration** - Managing multiple container instances
- ✅ **Load Balancing** - Distributing traffic across replicas
- ✅ **Auto-scaling** - Dynamic scaling based on resource usage
- ✅ **Service Discovery** - Kubernetes networking concepts
- ✅ **Resource Management** - CPU and memory limits/requests
- ✅ **High Availability** - Multi-replica deployments
- ✅ **Zero-downtime Deployments** - Rolling update strategies

## 🔗 Next Steps

- **Production Deployment**: Learn about managed Kubernetes (AKS, EKS, GKE)
- **Advanced Networking**: Ingress controllers and SSL termination
- **Persistent Storage**: StatefulSets and persistent volumes
- **Security**: RBAC, network policies, and pod security standards
- **Monitoring**: Prometheus and Grafana integration
- **GitOps**: ArgoCD or Flux for automated deployments

## 📚 Useful Commands Reference

```bash
# Deployment management
kubectl get deployments
kubectl scale deployment my-webapp --replicas=5
kubectl rollout status deployment/my-webapp
kubectl rollout restart deployment/my-webapp

# Pod management
kubectl get pods -o wide
kubectl exec -it <pod-name> -- /bin/sh
kubectl port-forward <pod-name> 8080:3001

# Service management
kubectl get services
kubectl describe service my-webapp-service

# Troubleshooting
kubectl logs -f -l app=my-webapp
kubectl get events --sort-by=.metadata.creationTimestamp
kubectl describe pods -l app=my-webapp
```

---

**Congratulations! 🎉** 

*You've successfully deployed a scalable web application on Kubernetes. This is a major milestone in your DevOps journey!*