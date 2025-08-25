# MetalLB Setup Guide

This guide provides detailed instructions for setting up MetalLB load balancer in your Kubernetes cluster.

## Overview

MetalLB is a load balancer implementation for bare metal Kubernetes clusters, using standard routing protocols. It provides the ability to create LoadBalancer services that work outside of cloud environments.

## Prerequisites

- Kubernetes cluster must be running
- CNI plugin must be installed (Flannel in this case)
- kubectl must be configured and accessible
- All nodes must be in the same L2 network

## Network Configuration

### IP Address Pool

The MetalLB configuration uses the following IP range:
- **Start IP**: 10.0.2.240
- **End IP**: 10.0.2.250
- **Total IPs**: 11 addresses

**Important**: Make sure this IP range:
1. Is in the same subnet as your cluster nodes
2. Is outside the DHCP range of your network
3. Is not used by other services

### Customizing IP Range

To customize the IP range, modify the `metallb_ip_pool` variable in your playbook:

```yaml
metallb_ip_pool:
  - start: "192.168.1.240"
    end: "192.168.1.250"
    name: "production-pool"
```

## Installation Steps

### 1. Run the Ansible Playbook

```bash
# Run the complete setup including MetalLB
ansible-playbook -i inventory.yml site.yml

# Or run only MetalLB installation
ansible-playbook -i inventory.yml site.yml --tags metallb
```

### 2. Verify Installation

Check that MetalLB components are running:

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

Expected output:
```
NAME                    READY   STATUS    RESTARTS   AGE
controller-xxx         1/1     Running   0          2m
speaker-xxx            1/1     Running   0          2m
speaker-xxx            1/1     Running   0          2m
```

## Testing MetalLB

### 1. Deploy Test Application

The demo application is automatically deployed. You can also deploy manually:

```bash
# Create test deployment
kubectl create deployment nginx --image=nginx

# Create LoadBalancer service
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# Check service
kubectl get service nginx
```

### 2. Verify External IP Assignment

```bash
# Get the external IP
kubectl get service nginx -o jsonpath='{.status.loadBalancer.ingress[0].ip}'

# Test connectivity
curl http://<EXTERNAL_IP>
```

### 3. Check MetalLB Logs

```bash
# Check controller logs
kubectl logs -n metallb-system -l app=metallb -c controller

# Check speaker logs
kubectl logs -n metallb-system -l app=metallb -c speaker
```

## Troubleshooting

### Common Issues

#### 1. Service Stuck in Pending

**Symptoms**: Service shows `<pending>` for external IP

**Solutions**:
- Check MetalLB pods are running
- Verify IP address pool configuration
- Check network connectivity between nodes

```bash
# Check MetalLB status
kubectl get pods -n metallb-system

# Check IP address pool
kubectl get ipaddresspools -n metallb-system -o yaml

# Check L2 advertisement
kubectl get l2advertisements -n metallb-system -o yaml
```

#### 2. Cannot Access External IP

**Symptoms**: External IP assigned but not accessible

**Solutions**:
- Verify IP range is in correct subnet
- Check firewall rules
- Ensure nodes are in same L2 network

```bash
# Check if IP is reachable
ping <EXTERNAL_IP>

# Check ARP table
arp -a | grep <EXTERNAL_IP>
```

#### 3. MetalLB Pods Not Starting

**Symptoms**: MetalLB pods in CrashLoopBackOff or Pending

**Solutions**:
- Check node resources
- Verify RBAC permissions
- Check for conflicting network configurations

```bash
# Check pod events
kubectl describe pod -n metallb-system <pod-name>

# Check node resources
kubectl describe node <node-name>
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

# Test network connectivity
kubectl run test-pod --image=busybox --rm -it --restart=Never -- nslookup kubernetes.default
```

## Advanced Configuration

### Multiple IP Pools

You can configure multiple IP pools for different purposes:

```yaml
metallb_ip_pool:
  - start: "10.0.2.240"
    end: "10.0.2.245"
    name: "production-pool"
  - start: "10.0.2.246"
    end: "10.0.2.250"
    name: "development-pool"
```

### BGP Configuration

For larger clusters, you can use BGP instead of Layer 2:

```yaml
metallb_bgp_config:
  enabled: true
  peers:
    - peer-address: "192.168.1.1"
      peer-asn: 65000
      my-asn: 65001
```

### Service Annotations

Use annotations to control MetalLB behavior:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
  annotations:
    metallb.universe.tf/allow-shared-ip: "true"
    metallb.universe.tf/address-pool: "production-pool"
spec:
  type: LoadBalancer
```

## Monitoring

### Metrics

MetalLB exposes Prometheus metrics:

```bash
# Port forward to access metrics
kubectl port-forward -n metallb-system svc/controller 7472:7472

# Access metrics
curl http://localhost:7472/metrics
```

### Logs

Monitor MetalLB logs for issues:

```bash
# Follow controller logs
kubectl logs -f -n metallb-system -l app=metallb -c controller

# Follow speaker logs
kubectl logs -f -n metallb-system -l app=metallb -c speaker
```

## Security Considerations

1. **Network Isolation**: Ensure MetalLB IP range is properly isolated
2. **RBAC**: MetalLB uses RBAC for security
3. **Network Policies**: Consider implementing network policies
4. **Monitoring**: Monitor for unauthorized access attempts

## Performance Optimization

1. **IP Pool Size**: Allocate sufficient IP addresses for your services
2. **Node Distribution**: Ensure speakers are running on all nodes
3. **Network Latency**: Minimize network latency between nodes
4. **Resource Limits**: Monitor resource usage of MetalLB pods

## Backup and Recovery

### Backup Configuration

```bash
# Backup MetalLB configuration
kubectl get ipaddresspools -n metallb-system -o yaml > metallb-ip-pools.yaml
kubectl get l2advertisements -n metallb-system -o yaml > metallb-l2-adv.yaml
```

### Restore Configuration

```bash
# Restore MetalLB configuration
kubectl apply -f metallb-ip-pools.yaml
kubectl apply -f metallb-l2-adv.yaml
```

## References

- [MetalLB Official Documentation](https://metallb.universe.tf/)
- [Kubernetes Service Types](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)
