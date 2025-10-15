# Demo Application Role

This Ansible role deploys a demo application to test MetalLB load balancer functionality.

## Description

This role deploys a simple nginx application with LoadBalancer service type to demonstrate MetalLB functionality. It includes:

- Deployment of nginx application
- Service configuration with LoadBalancer type
- Verification of external IP assignment
- Resource limits and requests

## Requirements

- Kubernetes cluster must be running
- MetalLB must be installed and configured
- kubectl must be configured and accessible

## Role Variables

### Default Variables

```yaml
# Demo application configuration
demo_app:
  name: "nginx-demo"
  namespace: "demo"
  replicas: 3
  image: "nginx:latest"
  port: 80
  service_type: "LoadBalancer"
  
# Enable demo application deployment
deploy_demo_app: true

# Enable demo application service
deploy_demo_service: true

# Demo application labels
demo_labels:
  app: "nginx-demo"
  environment: "demo"
```

## Usage

### Basic Usage

Include this role in your playbook after MetalLB installation:

```yaml
- name: Deploy demo application
  hosts: master_nodes
  become: true
  roles:
    - demo_app
```

### With Custom Configuration

```yaml
- name: Deploy demo application with custom config
  hosts: master_nodes
  become: true
  vars:
    demo_app:
      name: "my-app"
      namespace: "production"
      replicas: 5
      image: "my-app:latest"
      port: 8080
  roles:
    - demo_app
```

## Quick Start

### 1. Prerequisites
- Kubernetes cluster must be running
- MetalLB must be installed and configured
- kubectl must be configured and accessible

### 2. Deploy Demo Application
```bash
# Deploy demo application role
ansible-playbook -i inventory.yml site.yml --tags demo_app
```

### 3. Verify Deployment
```bash
# Check demo namespace
kubectl get namespace demo

# Check deployment
kubectl get deployment -n demo

# Expected output:
# NAME        READY   UP-TO-DATE   AVAILABLE   AGE
# nginx-demo  3/3     3            3           2m

# Check pods
kubectl get pods -n demo

# Expected output:
# NAME                         READY   STATUS    RESTARTS   AGE
# nginx-demo-xxx               1/1     Running   0          2m
# nginx-demo-xxx               1/1     Running   0          2m
# nginx-demo-xxx               1/1     Running   0          2m
```

### 4. Test LoadBalancer Service
```bash
# Check service
kubectl get service -n demo

# Expected output:
# NAME                TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
# nginx-demo-service  LoadBalancer   10.96.xxx.xxx   10.0.2.240     80:xxxxx/TCP   2m

# Test connectivity
curl http://10.0.2.240

# Expected output - HTML page with nginx welcome message
```

## Verification

After deployment, you can verify the application:

```bash
# Check deployment
kubectl get deployment -n demo

# Check pods
kubectl get pods -n demo

# Check service
kubectl get service -n demo

# Test the application
curl http://<EXTERNAL_IP>
```

## Expected Results

After successful deployment, you should have:

### 1. Application Components
- ✅ `demo` namespace created
- ✅ Nginx deployment with 3 replicas
- ✅ All pods in Running status
- ✅ LoadBalancer service created
- ✅ External IP assigned from MetalLB pool

### 2. Service Functionality
- ✅ Service accessible via external IP
- ✅ Load balancing across 3 nginx pods
- ✅ HTTP response from nginx welcome page
- ✅ Service type LoadBalancer working correctly

### 3. Resource Configuration
- ✅ Resource limits and requests set
- ✅ Proper labels and selectors
- ✅ MetalLB annotations configured
- ✅ Port mapping configured correctly

## Testing the Application

### Manual Testing
```bash
# Get the external IP
EXTERNAL_IP=$(kubectl get service nginx-demo-service -n demo -o jsonpath='{.status.loadBalancer.ingress[0].ip}')

# Test HTTP connectivity
curl -I http://$EXTERNAL_IP

# Test multiple requests (load balancing)
for i in {1..10}; do
  curl -s http://$EXTERNAL_IP | grep "Welcome to nginx"
done
```

### Automated Testing
```bash
# Run the test script
./scripts/test-metallb.sh
```

## Customization

### Modify Application Configuration
Edit `demo_app/defaults/main.yml`:

```yaml
demo_app:
  name: "my-custom-app"
  namespace: "production"
  replicas: 5
  image: "my-app:latest"
  port: 8080
```

### Add Custom Labels
```yaml
demo_labels:
  app: "my-custom-app"
  environment: "production"
  version: "v1.0.0"
```

### Modify Resource Limits
```yaml
# In the deployment template
resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

## Troubleshooting

### Common Issues

1. **Pods not starting:**
   ```bash
   # Check pod events
   kubectl describe pod -n demo <pod-name>
   
   # Check pod logs
   kubectl logs -n demo <pod-name>
   ```

2. **Service not getting external IP:**
   ```bash
   # Check MetalLB status
   kubectl get pods -n metallb-system
   
   # Check service events
   kubectl get events -n demo
   ```

3. **Cannot access application:**
   ```bash
   # Check if external IP is reachable
   ping <EXTERNAL_IP>
   
   # Check service configuration
   kubectl describe service -n demo nginx-demo-service
   ```

### Debug Commands

```bash
# Check all resources in demo namespace
kubectl get all -n demo

# Check service endpoints
kubectl get endpoints -n demo

# Check pod logs
kubectl logs -n demo -l app=nginx-demo

# Check events
kubectl get events -n demo --sort-by='.lastTimestamp'
```

## Dependencies

This role depends on:
- `kubernetes_master` role
- `metallb` role

## License

MIT
