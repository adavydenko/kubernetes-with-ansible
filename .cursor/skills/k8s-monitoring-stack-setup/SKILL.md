name: k8s-monitoring-stack-setup
description: Set up comprehensive monitoring stack for Kubernetes cluster with Prometheus, Grafana, and exporters. Use when user requests monitoring, needs observability, or wants to track cluster metrics.
---

# Monitoring Stack Setup

Set up comprehensive monitoring stack for Kubernetes cluster including Prometheus for metrics collection, Grafana for visualization, Node Exporter for node metrics, and optional GPU monitoring.

## When to Use

- User requests monitoring setup
- Need to track cluster health and performance
- User mentions "monitoring", "metrics", "observability", or "dashboards"
- After setting up storage (monitoring needs persistent storage)
- Before deploying production workloads

## Instructions

### 1. Verify Prerequisites

Check required components exist:
- Kubernetes cluster is running
- Storage system available (StorageClass for PVCs)
- Network connectivity between nodes
- Sufficient resources (memory, CPU for monitoring stack)

### 2. Plan Monitoring Components

Determine what to monitor:
- **Node Metrics**: CPU, memory, disk, network (Node Exporter)
- **Kubernetes Metrics**: Pods, services, nodes (kube-state-metrics)
- **Application Metrics**: Custom application metrics
- **GPU Metrics**: If cluster has GPU nodes (NVIDIA Exporter)

### 3. Create Monitoring Namespace

```yaml
- name: Create monitoring namespace
  command: kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
```

### 4. Set Up Storage for Monitoring

Create PVCs for monitoring data:
```yaml
# Prometheus data (needs most storage)
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
  namespace: monitoring
spec:
  storageClassName: "local-storage"
  resources:
    requests:
      storage: "10Gi"  # Adjust based on retention needs

# Grafana data (dashboards, users)
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-data
  namespace: monitoring
spec:
  storageClassName: "local-storage"
  resources:
    requests:
      storage: "5Gi"
```

### 5. Configure Prometheus

Create Prometheus configuration:
```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-config
  namespace: monitoring
data:
  prometheus.yml: |
    global:
      scrape_interval: 15s
      evaluation_interval: 15s
    
    scrape_configs:
      # Kubernetes API servers
      - job_name: 'kubernetes-apiservers'
        kubernetes_sd_configs:
          - role: endpoints
      
      # Kubernetes nodes
      - job_name: 'kubernetes-nodes'
        kubernetes_sd_configs:
          - role: node
      
      # Node Exporter
      - job_name: 'node-exporter'
        kubernetes_sd_configs:
          - role: endpoints
        relabel_configs:
          - source_labels: [__meta_kubernetes_service_name]
            action: keep
            regex: node-exporter
      
      # Pods with prometheus.io/scrape annotation
      - job_name: 'kubernetes-pods'
        kubernetes_sd_configs:
          - role: pod
        relabel_configs:
          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
            action: keep
            regex: true
```

### 6. Deploy Prometheus

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prometheus
  namespace: monitoring
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: prometheus
        image: prom/prometheus:v2.45.0
        args:
          - '--config.file=/etc/prometheus/prometheus.yml'
          - '--storage.tsdb.path=/prometheus'
          - '--storage.tsdb.retention.time=15d'
        volumeMounts:
        - name: prometheus-config
          mountPath: /etc/prometheus
        - name: prometheus-data
          mountPath: /prometheus
      volumes:
      - name: prometheus-config
        configMap:
          name: prometheus-config
      - name: prometheus-data
        persistentVolumeClaim:
          claimName: prometheus-data
```

### 7. Deploy Grafana

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: grafana
  namespace: monitoring
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: grafana
        image: grafana/grafana:9.5.2
        env:
        - name: GF_SECURITY_ADMIN_PASSWORD
          value: "admin123"  # Change in production!
        volumeMounts:
        - name: grafana-data
          mountPath: /var/lib/grafana
      volumes:
      - name: grafana-data
        persistentVolumeClaim:
          claimName: grafana-data
```

### 8. Deploy Node Exporter (DaemonSet)

```yaml
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: node-exporter
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: node-exporter
  template:
    metadata:
      labels:
        app: node-exporter
    spec:
      containers:
      - name: node-exporter
        image: prom/node-exporter:v1.6.1
        args:
          - '--path.procfs=/host/proc'
          - '--path.sysfs=/host/sys'
          - '--path.rootfs=/host/root'
        volumeMounts:
        - name: proc
          mountPath: /host/proc
          readOnly: true
        - name: sys
          mountPath: /host/sys
          readOnly: true
        - name: root
          mountPath: /host/root
          readOnly: true
      volumes:
      - name: proc
        hostPath:
          path: /proc
      - name: sys
        hostPath:
          path: /sys
      - name: root
        hostPath:
          path: /
```

### 9. Create Services

```yaml
# Prometheus Service
apiVersion: v1
kind: Service
metadata:
  name: prometheus
  namespace: monitoring
spec:
  selector:
    app: prometheus
  ports:
    - port: 9090
  type: ClusterIP

# Grafana Service (can be LoadBalancer for external access)
apiVersion: v1
kind: Service
metadata:
  name: grafana
  namespace: monitoring
spec:
  selector:
    app: grafana
  ports:
    - port: 3000
  type: LoadBalancer  # Uses existing MetalLB

# Node Exporter Service
apiVersion: v1
kind: Service
metadata:
  name: node-exporter
  namespace: monitoring
spec:
  selector:
    app: node-exporter
  ports:
    - port: 9100
  type: ClusterIP
```

### 10. Configure Grafana Data Source

After Grafana is running, configure Prometheus as data source:
- URL: `http://prometheus.monitoring.svc.cluster.local:9090`
- Access: Server (default)
- Save & Test

### 11. Import Dashboards

Recommended Grafana dashboards:
- **Kubernetes Cluster Monitoring**: ID 315
- **Node Exporter Dashboard**: ID 1860
- **Prometheus Stats**: ID 3662

### 12. Optional: Add GPU Monitoring

If cluster has GPU nodes:
```yaml
# NVIDIA Node Exporter DaemonSet
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: nvidia-exporter
  namespace: monitoring
spec:
  template:
    spec:
      containers:
      - name: nvidia-exporter
        image: dcgmexporter:v1.2.0
        securityContext:
          privileged: true
      tolerations:
      - key: nvidia.com/gpu
        operator: Exists
        effect: NoSchedule
```

Add to Prometheus config:
```yaml
- job_name: 'nvidia-exporter'
  kubernetes_sd_configs:
    - role: endpoints
  relabel_configs:
    - source_labels: [__meta_kubernetes_service_name]
      action: keep
      regex: nvidia-exporter
```

## Best Practices

- ✅ **Storage First**: Set up storage before monitoring (needs PVCs)
- ✅ **Resource Limits**: Set appropriate limits for Prometheus/Grafana
- ✅ **Retention Policy**: Configure retention based on storage capacity
- ✅ **Security**: Change default Grafana password
- ✅ **Node Exporter**: Always include for node metrics
- ✅ **Wait for Readiness**: Wait for pods before proceeding
- ✅ **Test Access**: Verify Prometheus and Grafana are accessible

## Common Patterns

### Basic Monitoring Stack
```
Prometheus (metrics collection)
  ↓
Grafana (visualization)
  ↓
Node Exporter (node metrics)
```

### Full Monitoring Stack
```
Prometheus (metrics)
  ↓
Grafana (dashboards)
  ↓
Node Exporter (node metrics)
  ↓
NVIDIA Exporter (GPU metrics, optional)
  ↓
Alertmanager (alerts, optional)
```

## What NOT to Do

- ❌ Don't skip storage setup (monitoring needs persistent storage)
- ❌ Don't forget Node Exporter (essential for node metrics)
- ❌ Don't use default passwords in production
- ❌ Don't skip resource limits (monitoring can be resource-intensive)
- ❌ Don't forget to configure Prometheus scrape configs
- ❌ Don't skip readiness checks

## Example Workflow

1. **Verify**: Storage system available
2. **Create**: Monitoring namespace
3. **Create**: PVCs for Prometheus and Grafana
4. **Configure**: Prometheus with scrape configs
5. **Deploy**: Prometheus deployment
6. **Deploy**: Grafana deployment
7. **Deploy**: Node Exporter DaemonSet
8. **Create**: Services for all components
9. **Wait**: For all pods to be ready
10. **Configure**: Grafana data source
11. **Import**: Recommended dashboards
12. **Test**: Access and verify metrics collection

## Example Output

After setup, verify:
```bash
# Check pods
kubectl get pods -n monitoring

# Check services
kubectl get svc -n monitoring

# Access Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Open http://localhost:9090

# Access Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Open http://localhost:3000 (admin/admin123)
```

## References

- Prometheus: https://prometheus.io/docs/
- Grafana: https://grafana.com/docs/
- Node Exporter: https://github.com/prometheus/node_exporter
- Kubernetes Monitoring: https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/

