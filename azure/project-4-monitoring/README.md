# DevOps Monitoring Stack with Prometheus & Grafana

A complete monitoring solution for your applications using Prometheus for metrics collection and Grafana for beautiful dashboards and visualization.

## 🎯 What This Project Demonstrates

- **📊 Metrics Collection** - Prometheus scraping and storing application metrics
- **📈 Data Visualization** - Grafana dashboards with charts and graphs
- **🚨 Monitoring Best Practices** - Setting up production-ready monitoring
- **🔍 Observability** - Application health and performance tracking
- **📋 Dashboard Creation** - Custom and pre-built monitoring dashboards
- **⚡ Real-time Monitoring** - Live metrics and alerting capabilities

## 📋 Prerequisites

Before you begin, ensure you have:

- [Docker Desktop](https://www.docker.com/products/docker-desktop) installed and running
- A web browser (Chrome, Firefox, Safari, or Edge)
- Your web application from previous projects (optional, for testing)
- Basic understanding of metrics and monitoring concepts

## 📁 Project Structure

```
project-4-monitoring/
├── docker-compose.yml          # Container orchestration configuration
├── prometheus.yml              # Prometheus configuration and targets
├── README.md                  # This file
```

## 🚀 Step-by-Step Setup

### 1. Start the Monitoring Stack

```bash
# Navigate to the monitoring project directory
cd project-4-monitoring

# Start Prometheus and Grafana containers
docker-compose up -d

# Verify containers are running
docker-compose ps

# Expected output:
# prometheus    running    0.0.0.0:9090->9090/tcp
# grafana       running    0.0.0.0:3002->3000/tcp
```

### 2. Access the Monitoring Tools

#### Prometheus (Metrics Database)
- **URL**: http://localhost:9090
- **Purpose**: Query metrics and check targets

#### Grafana (Dashboard Interface)
- **URL**: http://localhost:3002
- **Default Login**: 
  - Username: `admin`
  - Password: `admin`
- **Purpose**: Create and view dashboards

### 3. Configure Grafana Data Source

1. **Login to Grafana** at http://localhost:3002
2. **Add Data Source**:
   - Click **"Add your first data source"**
   - Select **"Prometheus"**
   - URL: `http://prometheus:9090`
   - Click **"Save & Test"**
   - You should see: ✅ **"Data source is working"**

### 4. Create Your First Dashboard

#### Option A: Import Pre-built Dashboard
1. Click **"+"** → **"Import"**
2. **Dashboard ID**: `1860` (Node Exporter Full)
3. Click **"Load"**
4. Select **Prometheus** as data source
5. Click **"Import"**

#### Option B: Create Custom Dashboard
1. Click **"+"** → **"Dashboard"** → **"Add new panel"**
2. **Query**: `up`
3. **Panel Title**: "Service Status"
4. **Visualization**: Time series
5. Click **"Apply"**

### 5. Monitor Your Web Application (Optional)

If you have your web app from previous projects running:

1. **Update prometheus.yml** to include your app:
   ```yaml
   - job_name: 'my-webapp'
     static_configs:
       - targets: ['host.docker.internal:3001']
     metrics_path: '/metrics'
     scrape_interval: 30s
   ```

2. **Restart Prometheus**:
   ```bash
   docker-compose restart prometheus
   ```

3. **Verify target** at http://localhost:9090/targets

## 📊 Available Metrics and Dashboards

### Prometheus Self-Monitoring
- `prometheus_http_requests_total` - HTTP requests to Prometheus
- `prometheus_tsdb_head_series` - Number of series in memory
- `up` - Target availability (1=up, 0=down)

### Custom Application Metrics (if webapp configured)
- `webapp_requests_total` - Total HTTP requests
- `webapp_uptime_seconds` - Application uptime
- `webapp_memory_usage_bytes` - Memory consumption

### Useful Grafana Queries
```promql
# Request rate per second
rate(webapp_requests_total[5m])

# Memory usage in MB
webapp_memory_usage_bytes / 1024 / 1024

# Service availability percentage
avg_over_time(up[1h]) * 100
```

## 🔧 Configuration Details

### Prometheus Configuration
```yaml
global:
  scrape_interval: 15s
  evaluation_interval: 15s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
      - targets: ['localhost:9090']
  
  - job_name: 'my-webapp'
    static_configs:
      - targets: ['host.docker.internal:3001']
```

### Docker Compose Services
- **Prometheus**: Port 9090, persistent data storage
- **Grafana**: Port 3002, admin user configured
- **Volumes**: Data persistence for both services

## 🛠️ Troubleshooting Guide

### ❌ Can't Access Grafana or Prometheus

**Check containers are running:**
```bash
docker-compose ps
# Both should show "running"
```

**Restart containers:**
```bash
docker-compose down
docker-compose up -d
```

**Check for port conflicts:**
```bash
# Windows
netstat -ano | findstr :3002
netstat -ano | findstr :9090

# Mac/Linux
lsof -i :3002
lsof -i :9090
```

### ❌ Data Source Connection Failed

**Error**: "HTTP Error Bad Gateway"

**Solution**: Use `http://prometheus:9090` (not `localhost:9090`) as the data source URL in Grafana.

**Test container communication:**
```bash
docker-compose exec grafana ping prometheus
```

### ❌ No Data in Dashboards

**Check time range**: Set to "Last 15 minutes" instead of "Last 6 hours"

**Wait for data collection**: Prometheus scrapes every 15 seconds

**Verify Prometheus targets**:
- Go to http://localhost:9090/targets
- All targets should show "UP"

**Test basic query**:
- In Prometheus UI, try query: `up`

### ❌ Can't Monitor My Application

**Verify app is accessible:**
```bash
curl http://localhost:3001/health
curl http://localhost:3001/metrics
```

**Check prometheus.yml configuration**

**Restart Prometheus after config changes:**
```bash
docker-compose restart prometheus
```

### ❌ Import Dashboard Fails

**Add Prometheus data source first**

**Try alternative dashboard IDs**: `3662`, `1860`, `11074`

**Manual import**: Download JSON from grafana.com and upload directly

### ❌ Memory or Performance Issues

**Increase Docker Desktop memory**: Settings → Resources → 4GB+

**Add resource limits to docker-compose.yml:**
```yaml
deploy:
  resources:
    limits:
      memory: 512m
```

## 📈 Advanced Dashboard Examples

### Application Performance Dashboard
```promql
# Request Rate
rate(webapp_requests_total[5m])

# Error Rate
rate(webapp_errors_total[5m]) / rate(webapp_requests_total[5m])

# Response Time P95
histogram_quantile(0.95, webapp_request_duration_seconds_bucket)
```

### System Resource Dashboard
```promql
# CPU Usage
rate(process_cpu_seconds_total[5m]) * 100

# Memory Usage
process_resident_memory_bytes / 1024 / 1024

# Disk I/O
rate(process_io_bytes_total[5m])
```

## 🧹 Cleanup

### Stop Monitoring Stack
```bash
# Stop containers (data preserved)
docker-compose down

# Remove everything including data
docker-compose down -v
```

### Remove Docker Images (Optional)
```bash
docker image rm prom/prometheus:latest
docker image rm grafana/grafana:latest
```

## 🎓 What You've Learned

By completing this project, you've mastered:

- ✅ **Prometheus Fundamentals** - Metrics collection and storage
- ✅ **Grafana Mastery** - Dashboard creation and visualization
- ✅ **Monitoring Best Practices** - Target configuration and data sources
- ✅ **Query Language (PromQL)** - Writing metrics queries
- ✅ **Observability Concepts** - Metrics, monitoring, and alerting
- ✅ **Container Monitoring** - Docker-based monitoring stack
- ✅ **Dashboard Design** - Creating effective visualizations
- ✅ **Troubleshooting** - Debugging monitoring systems

## 🔗 Next Steps

- **Alerting**: Set up Grafana alerts for critical metrics
- **Advanced Dashboards**: Create business-specific dashboards
- **Log Monitoring**: Add ELK stack (Elasticsearch, Logstash, Kibana)
- **Distributed Tracing**: Implement Jaeger or Zipkin
- **Production Monitoring**: Deploy to cloud with managed services
- **Custom Exporters**: Create custom metrics for your applications

## 📚 Useful Resources

### Prometheus Documentation
- [Prometheus Query Language](https://prometheus.io/docs/prometheus/latest/querying/basics/)
- [Recording Rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/)
- [Alerting Rules](https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/)

### Grafana Resources
- [Dashboard Gallery](https://grafana.com/grafana/dashboards/)
- [Panel Types](https://grafana.com/docs/grafana/latest/panels/)
- [Variables and Templating](https://grafana.com/docs/grafana/latest/variables/)

### Useful Commands
```bash
# View logs
docker-compose logs prometheus
docker-compose logs grafana

# Access container shell
docker-compose exec prometheus sh
docker-compose exec grafana bash

# Restart specific service
docker-compose restart prometheus
```

---

**Congratulations! 🎉** 

*You've built a production-ready monitoring stack! This foundation will serve you well in monitoring any application or infrastructure.*