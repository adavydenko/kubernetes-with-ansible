name: k8s-kubernetes-component-integration
description: Integrate new Kubernetes components with existing infrastructure, handling dependencies, storage, networking, and monitoring integration. Use when adding components to cluster or configuring component interactions.
---

# Kubernetes Component Integration

Integrate new Kubernetes components with existing cluster infrastructure, ensuring proper dependencies, storage integration, service discovery, and monitoring.

## When to Use

- Adding new component to existing Kubernetes cluster
- Configuring dependencies between components
- Integrating component with storage, networking, or monitoring
- Updating component to work with existing infrastructure
- User requests component that needs integration

## Instructions

### 1. Identify Dependencies

Determine what the component needs:
- **Storage**: Requires StorageClass? Needs PVC?
- **Networking**: Needs LoadBalancer? Ingress? Service discovery?
- **Monitoring**: Should be monitored? Needs metrics endpoint?
- **RBAC**: Requires ServiceAccount? Role? RoleBinding?
- **Other Components**: Depends on other components?

### 2. Check Existing Infrastructure

Verify dependencies exist:
- Check for StorageClass: `kubectl get storageclass`
- Check for LoadBalancer: `kubectl get svc -A | grep LoadBalancer`
- Check for monitoring: `kubectl get pods -n monitoring`
- Check for namespace: `kubectl get namespace`
- Verify component versions are compatible

### 3. Configure Storage Integration

If component needs storage:
```yaml
# Use existing StorageClass
storageClassName: "local-storage"  # From existing storage role

# Create PVC if needed
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: component-data
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: "local-storage"  # Use existing
  resources:
    requests:
      storage: "10Gi"
```

### 4. Configure Networking Integration

If component needs external access:
- **LoadBalancer**: Use existing MetalLB configuration
- **Ingress**: Configure ingress controller if available
- **Service Discovery**: Use Kubernetes DNS (service.namespace.svc.cluster.local)

Example LoadBalancer integration:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: component-service
spec:
  type: LoadBalancer  # Uses existing MetalLB
  selector:
    app: component
  ports:
    - port: 80
```

### 5. Configure Monitoring Integration

If component should be monitored:

#### Add to Prometheus scrape configs:
```yaml
scrape_configs:
  - job_name: 'component'
    kubernetes_sd_configs:
      - role: endpoints
    relabel_configs:
      - source_labels: [__meta_kubernetes_service_name]
        action: keep
        regex: component-service
```

#### Add annotations to Service:
```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/metrics"
```

### 6. Update site.yml Order

Ensure correct execution order in `ansible/playbooks/site.yml`:
```yaml
# Correct order:
1. kubernetes_master      # Base cluster
2. kubernetes_worker      # Worker nodes
3. kubernetes_network     # CNI
4. metallb               # LoadBalancer (depends on network)
5. storage               # Storage (depends on cluster)
6. monitoring            # Monitoring (depends on storage)
7. new_component         # New component (depends on dependencies)
```

### 7. Configure RBAC if Needed

If component needs special permissions:
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: component-sa
  namespace: component-namespace
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: component-role
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: component-rolebinding
subjects:
  - kind: ServiceAccount
    name: component-sa
roleRef:
  kind: Role
  name: component-role
  apiGroup: rbac.authorization.k8s.io
```

### 8. Test Integration

Verify integration works:
- Component can access storage (if needed)
- Component is accessible via service
- Component appears in monitoring (if configured)
- Component can discover other services
- No dependency errors in logs

## Best Practices

- ✅ **Check Dependencies First**: Verify required components exist
- ✅ **Use Existing Resources**: Reuse StorageClass, LoadBalancer, etc.
- ✅ **Follow Execution Order**: Add to site.yml in correct position
- ✅ **Test Integration**: Verify all connections work
- ✅ **Document Dependencies**: List what component needs
- ✅ **Handle Missing Dependencies**: Provide clear error messages
- ✅ **Use Standard Patterns**: Follow Kubernetes best practices

## Common Patterns

### Storage Integration Pattern

```yaml
# 1. Check StorageClass exists
- name: Verify StorageClass exists
  command: kubectl get storageclass local-storage
  register: storageclass_check
  failed_when: storageclass_check.rc != 0

# 2. Create PVC using existing StorageClass
- name: Create PVC
  kubectl apply -f pvc.yaml
  # pvc.yaml uses storageClassName: "local-storage"
```

### LoadBalancer Integration Pattern

```yaml
# 1. Service type LoadBalancer uses existing MetalLB
apiVersion: v1
kind: Service
spec:
  type: LoadBalancer  # Automatically uses MetalLB if installed
  # MetalLB assigns IP from configured pool
```

### Monitoring Integration Pattern

```yaml
# 1. Add scrape config to Prometheus
# In monitoring role, update prometheus-config ConfigMap

# 2. Add annotations to Service
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
```

## What NOT to Do

- ❌ Don't create new StorageClass if one exists
- ❌ Don't assume components exist without checking
- ❌ Don't ignore execution order in site.yml
- ❌ Don't hardcode service names (use variables)
- ❌ Don't skip integration testing
- ❌ Don't create duplicate resources

## Example Workflow

1. **Identify**: Component dependencies (storage, networking, monitoring)
2. **Check**: Existing infrastructure (StorageClass, LoadBalancer, monitoring)
3. **Configure**: Storage integration (use existing StorageClass)
4. **Configure**: Networking integration (use existing LoadBalancer)
5. **Configure**: Monitoring integration (add to Prometheus)
6. **Update**: site.yml with correct order
7. **Test**: Verify all integrations work
8. **Document**: Dependencies and integration points

## Example Integration

### Adding Monitoring Component

```yaml
# 1. Check storage exists
- name: Verify storage class
  command: kubectl get storageclass local-storage

# 2. Create PVC using existing storage
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-data
spec:
  storageClassName: "local-storage"  # Uses existing
  resources:
    requests:
      storage: "10Gi"

# 3. Component uses existing infrastructure
# - Storage: local-storage StorageClass
# - Networking: ClusterIP (internal)
# - Monitoring: Self-monitoring (Prometheus)
```

### Adding Application Component

```yaml
# 1. Uses existing LoadBalancer (MetalLB)
apiVersion: v1
kind: Service
spec:
  type: LoadBalancer  # Uses existing MetalLB

# 2. Can be monitored by existing Prometheus
metadata:
  annotations:
    prometheus.io/scrape: "true"
```

## References

- Kubernetes Service Discovery: https://kubernetes.io/docs/concepts/services-networking/service/
- Storage Classes: https://kubernetes.io/docs/concepts/storage/storage-classes/
- Service Accounts: https://kubernetes.io/docs/concepts/security/service-accounts/

