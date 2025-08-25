# Kubernetes Cluster Deployment Guide with MetalLB

This guide provides step-by-step instructions for deploying a complete Kubernetes cluster with MetalLB load balancer using Ansible.

## Prerequisites

### System Requirements
- **Control Node**: Ubuntu Desktop 24.10 or similar
- **Cluster Nodes**: Ubuntu Server 24.04 LTS
- **RAM**: Minimum 2GB per node (4GB recommended)
- **CPU**: 2 cores per node (4 cores recommended)
- **Storage**: 20GB per node
- **Network**: All nodes must be in the same L2 network

### Software Requirements
- Ansible 2.14+
- VirtualBox 7.0+ (for VM-based deployment)
- SSH access between all nodes

## Network Configuration

### IP Address Scheme
```
Control Node:    10.0.2.15
Master Node:     10.0.2.5
Worker Node 1:   10.0.2.6
Worker Node 2:   10.0.2.7
...
Worker Node N:   10.0.2.(5+N)

MetalLB Pool:    10.0.2.240 - 10.0.2.250
```

### Network Requirements
- All nodes must be able to communicate with each other
- Port 22 (SSH) must be open between nodes
- Kubernetes ports (6443, 2379-2380, 10250-10252) must be accessible
- MetalLB requires L2 network connectivity

## Step-by-Step Deployment

### 1. Prepare Virtual Machines

#### Create Control Node
```bash
# Create Ubuntu Desktop VM
# - Name: control
# - IP: 10.0.2.15
# - RAM: 2GB
# - Storage: 20GB
```

#### Create Master Node
```bash
# Create Ubuntu Server VM
# - Name: kube-master
# - IP: 10.0.2.5
# - RAM: 4GB
# - Storage: 30GB
```

#### Create Worker Nodes
```bash
# Create Ubuntu Server VMs
# - Name: kube-worker-01, kube-worker-02, etc.
# - IP: 10.0.2.6, 10.0.2.7, etc.
# - RAM: 4GB each
# - Storage: 30GB each
```

### 2. Configure Control Node

#### Install Ansible
```bash
sudo apt update
sudo apt install ansible -y
```

#### Setup SSH Keys
```bash
# Generate SSH key
ssh-keygen -t rsa -b 4096 -C "ansible@control"

# Copy keys to all nodes
ssh-copy-id user@10.0.2.5  # master
ssh-copy-id user@10.0.2.6  # worker-01
ssh-copy-id user@10.0.2.7  # worker-02
# ... repeat for all worker nodes
```

#### Clone Repository
```bash
git clone <repository-url>
cd kubernetes-with-ansible
```

### 3. Configure Inventory

Edit `inventory.yml` to match your environment:

```yaml
all:
  children:
    master_nodes:
      hosts:
        kube-master:
          ansible_host: 10.0.2.5
          ansible_user: your_username
    worker_nodes:
      hosts:
        kube-worker-01:
          ansible_host: 10.0.2.6
          ansible_user: your_username
        kube-worker-02:
          ansible_host: 10.0.2.7
          ansible_user: your_username
        # Add more worker nodes as needed
```

### 4. Customize Configuration (Optional)

#### Modify MetalLB IP Pool
Edit `metallb/defaults/main.yml`:

```yaml
metallb_ip_pool:
  - start: "10.0.2.240"
    end: "10.0.2.250"
    name: "first-pool"
```

#### Modify Demo Application
Edit `demo_app/defaults/main.yml`:

```yaml
demo_app:
  name: "my-app"
  namespace: "production"
  replicas: 5
  image: "my-app:latest"
  port: 8080
```

### 5. Deploy Cluster

#### Full Deployment
```bash
# Deploy complete cluster with MetalLB
ansible-playbook -i inventory.yml site.yml
```

#### Step-by-Step Deployment
```bash
# Deploy master node only
ansible-playbook -i inventory.yml site.yml --limit master_nodes

# Deploy network (Flannel)
ansible-playbook -i inventory.yml site.yml --tags kubernetes_network

# Deploy worker nodes
ansible-playbook -i inventory.yml site.yml --limit worker_nodes

# Deploy MetalLB
ansible-playbook -i inventory.yml site.yml --tags metallb

# Deploy demo application
ansible-playbook -i inventory.yml site.yml --tags demo_app
```

### 6. Verify Deployment

#### Check Cluster Status
```bash
# SSH to master node
ssh user@10.0.2.5

# Check cluster nodes
kubectl get nodes

# Check all pods
kubectl get pods --all-namespaces
```

#### Check MetalLB Installation
```bash
# Check MetalLB namespace
kubectl get namespace metallb-system

# Check MetalLB pods
kubectl get pods -n metallb-system

# Check IP address pools
kubectl get ipaddresspools -n metallb-system

# Check L2 advertisements
kubectl get l2advertisements -n metallb-system
```

#### Test LoadBalancer Functionality
```bash
# Run test script
./scripts/test-metallb.sh

# Or manually test
kubectl get service nginx-demo-service -n demo
curl http://<EXTERNAL_IP>
```

## Post-Deployment Configuration

### 1. Configure kubectl on Control Node

```bash
# Copy kubeconfig from master
scp user@10.0.2.5:/etc/kubernetes/admin.conf ~/.kube/config

# Set permissions
chmod 600 ~/.kube/config

# Test connection
kubectl get nodes
```

### 2. Install Additional Tools (Optional)

#### Install Helm
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

#### Install kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### 3. Configure Monitoring (Optional)

#### Install Prometheus Operator
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

#### Install Grafana
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
```

## Troubleshooting

### Common Issues

#### 1. Nodes Not Joining Cluster
```bash
# Check join command on master
kubeadm token create --print-join-command

# Check kubelet logs on worker
sudo journalctl -u kubelet -f
```

#### 2. MetalLB Not Assigning IPs
```bash
# Check MetalLB logs
kubectl logs -n metallb-system -l app=metallb -c controller
kubectl logs -n metallb-system -l app=metallb -c speaker

# Check IP pool configuration
kubectl get ipaddresspools -n metallb-system -o yaml
```

#### 3. Network Connectivity Issues
```bash
# Test connectivity between nodes
ping 10.0.2.5  # from worker to master
ping 10.0.2.6  # from master to worker

# Check Flannel pods
kubectl get pods -n kube-flannel
```

### Debug Commands

```bash
# Check cluster events
kubectl get events --sort-by='.lastTimestamp'

# Check node resources
kubectl describe node <node-name>

# Check pod details
kubectl describe pod <pod-name> -n <namespace>

# Check service details
kubectl describe service <service-name> -n <namespace>
```

## Maintenance

### Backup Configuration

```bash
# Backup cluster configuration
kubectl get all --all-namespaces -o yaml > cluster-backup.yaml

# Backup MetalLB configuration
kubectl get ipaddresspools -n metallb-system -o yaml > metallb-ip-pools.yaml
kubectl get l2advertisements -n metallb-system -o yaml > metallb-l2-adv.yaml
```

### Update Cluster

```bash
# Update MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

# Update Kubernetes
kubectl drain <node-name> --ignore-daemonsets
# Update node
kubectl uncordon <node-name>
```

### Scale Cluster

#### Add Worker Node
1. Create new VM with Ubuntu Server 24.04
2. Add to inventory
3. Run worker deployment:
```bash
ansible-playbook -i inventory.yml site.yml --limit new-worker-node
```

#### Remove Worker Node
```bash
# Drain node
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# Remove from cluster
kubectl delete node <node-name>
```

## Security Considerations

### 1. Network Security
- Implement network policies
- Use firewall rules
- Monitor network traffic

### 2. Access Control
- Use RBAC for user access
- Implement service accounts
- Regular security updates

### 3. Monitoring
- Monitor cluster resources
- Set up alerting
- Regular backups

## Performance Optimization

### 1. Resource Allocation
- Monitor CPU and memory usage
- Adjust resource limits
- Optimize pod placement

### 2. Network Optimization
- Use appropriate CNI settings
- Optimize MetalLB configuration
- Monitor network latency

### 3. Storage Optimization
- Use appropriate storage classes
- Monitor disk usage
- Implement storage policies

## Support and Resources

### Documentation
- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [MetalLB Documentation](https://metallb.universe.tf/)
- [Ansible Documentation](https://docs.ansible.com/)

### Community
- [Kubernetes Slack](https://slack.k8s.io/)
- [MetalLB GitHub](https://github.com/metallb/metallb)
- [Ansible Community](https://docs.ansible.com/ansible/latest/community/)

### Monitoring and Logging
- Set up centralized logging
- Implement monitoring dashboards
- Configure alerting rules
