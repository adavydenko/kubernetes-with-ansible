---
name: ansible-role-development
description: Create well-structured Ansible roles for Kubernetes components following best practices. Use when creating new roles, extending existing roles, or refactoring Ansible automation.
---

# Ansible Role Development for Kubernetes

Create well-structured, maintainable Ansible roles for Kubernetes components following best practices for idempotency, modularity, and configurability.

## When to Use

- Creating a new Ansible role for Kubernetes component
- Extending existing role with new functionality
- Refactoring or improving existing role
- User requests Ansible automation for Kubernetes component
- Need to standardize role structure across project

## Instructions

### 1. Create Role Structure

Create standard Ansible role structure:

```
role_name/
├── defaults/main.yml      # Default variables (feature flags, versions)
├── tasks/main.yml         # Main installation tasks
├── handlers/main.yml      # Handlers (service restarts, reloads)
├── templates/             # Jinja2 templates for configs
├── files/                 # Static files to copy
├── vars/main.yml          # Role variables (if needed, prefer defaults)
├── meta/main.yml          # Role metadata and dependencies
├── README.md              # Role documentation
└── tests/                 # Role tests
    ├── inventory
    └── test.yml
```

### 2. Define Default Variables

Create `defaults/main.yml` with:
- Feature flags (enabled/disabled)
- Component versions
- Resource limits
- Configuration options
- Storage requirements

Example structure:
```yaml
---
# Component configuration
component_enabled: true
component_namespace: "component-namespace"
component_version: "v1.0.0"

# Storage configuration
component_storage_class: "local-storage"
component_storage_size: "10Gi"

# Resource limits
component_resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

### 3. Create Main Tasks

Structure `tasks/main.yml` following this pattern:

```yaml
---
# 1. Pre-conditions check
- name: Check prerequisites
  # Verify required components exist

# 2. Create namespace
- name: Create namespace
  kubectl create namespace {{ namespace }}

# 3. Create ConfigMaps/Secrets
- name: Create configuration
  # ConfigMaps, Secrets, etc.

# 4. Create PVC (if storage needed)
- name: Create PersistentVolumeClaim
  # Only if component needs storage

# 5. Create Deployment/DaemonSet/StatefulSet
- name: Create component deployment
  # Main component deployment

# 6. Create Service
- name: Create service
  # Service for component access

# 7. Wait for readiness
- name: Wait for component to be ready
  kubectl wait --for=condition=ready

# 8. Verification
- name: Verify installation
  # Check pods, services, etc.

# 9. Cleanup temporary files
- name: Clean up temporary files
  # Remove /tmp files created during installation
```

### 4. Implement Idempotency

Ensure tasks are idempotent:
- Use `kubectl apply` instead of `kubectl create`
- Use `--dry-run=client` with `kubectl create` when needed
- Check existence before creating resources
- Use `changed_when` to properly report changes

Example:
```yaml
- name: Create namespace
  command: kubectl create namespace {{ namespace }} --dry-run=client -o yaml | kubectl apply -f -
  register: namespace_create
  changed_when: "'created' in namespace_create.stdout"
```

### 5. Use Feature Flags

Make optional features configurable:
```yaml
# In defaults/main.yml
optional_feature_enabled: false

# In tasks/main.yml
- name: Create optional feature
  # ... tasks ...
  when: optional_feature_enabled
```

### 6. Handle Dependencies

Define dependencies in `meta/main.yml`:
```yaml
---
dependencies:
  - role: storage
    when: component_needs_storage
  - role: monitoring
    when: component_needs_monitoring
```

### 7. Wait for Readiness

Always wait for components to be ready:
```yaml
- name: Wait for pods to be ready
  command: kubectl wait --for=condition=ready pod -l app={{ component_name }} -n {{ namespace }} --timeout=300s
  when: component_enabled
```

### 8. Create Documentation

Write comprehensive `README.md`:
- Role description and purpose
- Configuration options (defaults/main.yml)
- Usage examples
- Dependencies
- Troubleshooting
- Examples

### 9. Create Test Script

Create test script in `scripts/test-component.sh`:
- Check prerequisites (kubectl available)
- Verify namespace exists
- Check pods are running
- Verify services
- Test functionality
- Cleanup test resources

## Best Practices

- ✅ **Idempotency**: Role can run multiple times safely
- ✅ **Modularity**: Role does one thing well
- ✅ **Configurability**: Settings via defaults/main.yml
- ✅ **Feature Flags**: Optional features via variables
- ✅ **Readiness Checks**: Wait for components to be ready
- ✅ **Cleanup**: Remove temporary files
- ✅ **Documentation**: Comprehensive README
- ✅ **Testing**: Test script for validation
- ✅ **Error Handling**: Proper error messages and checks

## Common Patterns

### Storage Component Pattern

```yaml
# 1. Create storage directories on nodes
- name: Create storage directories
  file:
    path: "{{ item.path }}"
    state: directory
  loop: "{{ storage_paths }}"
  when: inventory_hostname in groups['worker_nodes']

# 2. Create StorageClass
- name: Create StorageClass
  kubectl apply -f storage-class.yaml

# 3. Verify StorageClass
- name: Verify StorageClass
  command: kubectl get storageclass
```

### Monitoring Component Pattern

```yaml
# 1. Create namespace
# 2. Create PVCs for data persistence
# 3. Create ConfigMaps for configuration
# 4. Create Deployment (Prometheus, Grafana)
# 5. Create Services
# 6. Wait for readiness
# 7. Verify metrics collection
```

### DaemonSet Pattern (Node Exporter)

```yaml
# 1. Create DaemonSet (runs on all nodes)
# 2. Create Service (for discovery)
# 3. Wait for pods on all nodes
# 4. Verify metrics endpoint
```

## What NOT to Do

- ❌ Don't create resources without checking existence
- ❌ Don't skip readiness checks
- ❌ Don't leave temporary files
- ❌ Don't hardcode values (use variables)
- ❌ Don't create roles that do multiple unrelated things
- ❌ Don't skip error handling
- ❌ Don't forget to document configuration options

## Example Workflow

1. **Create**: Role directory structure
2. **Define**: Default variables in defaults/main.yml
3. **Implement**: Main tasks following pattern
4. **Add**: Feature flags for optional functionality
5. **Test**: Run role and verify idempotency
6. **Document**: Write README with examples
7. **Create**: Test script for validation
8. **Integrate**: Add to site.yml with proper order

## Example Role Structure

### defaults/main.yml
```yaml
---
component_enabled: true
component_namespace: "monitoring"
component_version: "v2.45.0"
component_storage_size: "10Gi"
component_resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"
```

### tasks/main.yml
```yaml
---
- name: Create namespace
  command: kubectl create namespace {{ component_namespace }} --dry-run=client -o yaml | kubectl apply -f -
  when: component_enabled

- name: Create component deployment
  copy:
    dest: /tmp/component-deployment.yaml
    content: |
      apiVersion: apps/v1
      kind: Deployment
      # ... deployment spec ...
  when: component_enabled

- name: Apply component deployment
  command: kubectl apply -f /tmp/component-deployment.yaml
  when: component_enabled

- name: Wait for component to be ready
  command: kubectl wait --for=condition=ready pod -l app=component -n {{ component_namespace }} --timeout=300s
  when: component_enabled
```

## References

- Ansible Best Practices: https://docs.ansible.com/ansible/latest/user_guide/playbooks_best_practices.html
- Ansible Role Structure: https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html
- Kubernetes Ansible Modules: https://docs.ansible.com/ansible/latest/collections/kubernetes/core/

