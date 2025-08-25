# MetalLB Role

This Ansible role installs and configures MetalLB load balancer for Kubernetes clusters.

## Description

MetalLB is a load balancer implementation for bare metal Kubernetes clusters, using standard routing protocols. This role provides:

- Installation of MetalLB using official manifests
- Configuration of IP address pools for LoadBalancer services
- Layer 2 advertisement setup
- Verification of installation

## Requirements

- Kubernetes cluster must be running
- kubectl must be configured and accessible
- Cluster must have a CNI plugin installed (Flannel, Calico, etc.)

## Role Variables

### Default Variables

```yaml
# MetalLB version to install
metallb_version: "v0.13.12"

# IP address pool configuration
metallb_ip_pool:
  - start: "10.0.2.240"
    end: "10.0.2.250"
    name: "first-pool"

# Layer 2 configuration
metallb_layer2_config:
  - name: "l2advertisement"
    interfaces: []  # Empty means all interfaces

# Namespace for MetalLB
metallb_namespace: "metallb-system"

# Enable MetalLB installation
install_metallb: true

# Enable IP address pool configuration
configure_ip_pool: true

# Enable Layer 2 advertisement
configure_layer2: true
```

### Customization

You can customize the IP address pool by modifying the `metallb_ip_pool` variable in your playbook:

```yaml
metallb_ip_pool:
  - start: "192.168.1.240"
    end: "192.168.1.250"
    name: "production-pool"
```

## Usage

### Basic Usage

Include this role in your playbook:

```yaml
- name: Install MetalLB
  hosts: master_nodes
  become: true
  roles:
    - metallb
```

### With Custom Configuration

```yaml
- name: Install MetalLB with custom configuration
  hosts: master_nodes
  become: true
  vars:
    metallb_ip_pool:
      - start: "192.168.1.240"
        end: "192.168.1.250"
        name: "production-pool"
  roles:
    - metallb
```

## Quick Start

### 1. Prerequisites
- Kubernetes cluster must be running
- kubectl must be configured and accessible
- All nodes must be in the same L2 network

### 2. Deploy MetalLB
```bash
# Deploy MetalLB role
ansible-playbook -i inventory.yml site.yml --tags metallb
```

### 3. Verify Installation
```bash
# Check MetalLB namespace
kubectl get namespace metallb-system

# Check MetalLB pods
kubectl get pods -n metallb-system

# Expected output:
# NAME                          READY   STATUS    RESTARTS   AGE
# controller-xxx                1/1     Running   0          2m
# speaker-xxx                   1/1     Running   0          2m
# speaker-xxx                   1/1     Running   0          2m

# Check IP address pools
kubectl get ipaddresspools -n metallb-system

# Check L2 advertisements
kubectl get l2advertisements -n metallb-system
```

### 4. Test LoadBalancer Functionality
```bash
# Create test deployment
kubectl create deployment nginx --image=nginx

# Create LoadBalancer service
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Check service
kubectl get service nginx

# Expected output:
# NAME    TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
# nginx   LoadBalancer   10.96.xxx.xxx   10.0.2.240     80:xxxxx/TCP   1m

# Test connectivity
curl http://10.0.2.240
```

## Verification

After installation, you can verify MetalLB is working:

```bash
# Check MetalLB pods
kubectl get pods -n metallb-system

# Check IP address pools
kubectl get ipaddresspools -n metallb-system

# Check L2 advertisements
kubectl get l2advertisements -n metallb-system

# Test with a sample service
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl get service nginx
```

## Expected Results

After successful deployment, you should have:

### 1. MetalLB Components
- ✅ `metallb-system` namespace created
- ✅ Controller pod running (1 replica)
- ✅ Speaker pods running (1 per node)
- ✅ IP address pool configured
- ✅ L2 advertisement configured

### 2. LoadBalancer Functionality
- ✅ Services of type `LoadBalancer` get external IPs
- ✅ IPs are assigned from configured pool (10.0.2.240-10.0.2.250)
- ✅ External IPs are accessible from outside cluster
- ✅ Load balancing works across multiple pods

### 3. Network Configuration
- ✅ Layer 2 mode enabled
- ✅ ARP responses configured
- ✅ Network connectivity established

## Troubleshooting

### Common Issues

1. **MetalLB pods not starting:**
   ```bash
   # Check pod events
   kubectl describe pod -n metallb-system <pod-name>
   
   # Check node resources
   kubectl describe node <node-name>
   ```

2. **External IP not assigned:**
   ```bash
   # Check MetalLB logs
   kubectl logs -n metallb-system -l app=metallb -c controller
   kubectl logs -n metallb-system -l app=metallb -c speaker
   
   # Check IP pool configuration
   kubectl get ipaddresspools -n metallb-system -o yaml
   ```

3. **Cannot access external IP:**
   ```bash
   # Check if IP is reachable
   ping <EXTERNAL_IP>
   
   # Check ARP table
   arp -a | grep <EXTERNAL_IP>
   ```

### Debug Commands

```bash
# Get detailed MetalLB configuration
kubectl get ipaddresspools -n metallb-system -o yaml
kubectl get l2advertisements -n metallb-system -o yaml

# Check MetalLB events
kubectl get events -n metallb-system

# Check service events
kubectl get events --field-selector involvedObject.name=nginx
```

## Dependencies

This role depends on:
- `kubernetes_master` role (for kubectl access)
- `kubernetes_network` role (for CNI plugin)

## License

MIT
