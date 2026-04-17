name: k8s-optional-feature-implementation
description: Implement optional features with feature flags and sensible defaults, making them easy to enable but not interfering with basic functionality. Use when adding features needed by some users but not all.
---

# Optional Feature Implementation

Implement optional features using feature flags with sensible defaults, making features easy to enable when needed but not interfering with basic functionality.

## Primary intent

Implement opt-in capabilities with flags/defaults so baseline deployments remain stable.

## Use when

- Adding features not needed by all users
- Supporting different configurations or use cases
- Adding experimental or advanced features
- Implementing GPU support, advanced monitoring, etc.
- User requests feature that should be optional

## Do NOT use when

- The task is deciding between several architectural options
- The task is full component integration with multiple dependencies
- The task is cluster-wide gap analysis
- The task is complete monitoring stack bootstrap

## Use other skills instead when

- Use `k8s-solution-design-with-alternatives` when option trade-offs are undecided
- Use `k8s-kubernetes-component-integration` when adding a full component to cluster
- Use `k8s-kubernetes-infrastructure-analysis` for pre-implementation audits

## Instructions

### 1. Identify Feature as Optional

Determine if feature should be optional:
- **Optional**: GPU monitoring (only if GPU nodes exist)
- **Optional**: Advanced alerting (not everyone needs it)
- **Optional**: Backup solutions (depends on requirements)
- **Required**: Core functionality (storage, networking)

### 2. Add Feature Flag to Defaults

Add feature flag in `defaults/main.yml`:
```yaml
---
# Optional feature configuration
optional_feature_enabled: false  # Disabled by default
optional_feature_namespace: "namespace-name"
optional_feature_version: "v1.0.0"
```

### 3. Use Conditional Logic in Tasks

Wrap feature implementation with condition:
```yaml
- name: Create optional feature
  # ... tasks ...
  when: optional_feature_enabled
```

### 4. Set Sensible Defaults

Choose default based on usage:
- **false by default**: For features needed by few (GPU monitoring)
- **true by default**: For features needed by most (basic monitoring)

Example:
```yaml
# GPU monitoring - false by default (most clusters don't have GPU)
nvidia_exporter_enabled: false

# Basic monitoring - true by default (most users need it)
prometheus_enabled: true
```

### 5. Document How to Enable

Provide clear instructions:
```markdown
## Enabling Optional Feature

1. Edit `defaults/main.yml`:
   ```yaml
   optional_feature_enabled: true
   ```

2. Re-run playbook:
   ```bash
   ansible-playbook -i inventory.yml site.yml --tags component
   ```

3. Verify installation:
   ```bash
   kubectl get pods -n namespace-name
   ```
```

### 6. Handle Dependencies

If optional feature has dependencies:
```yaml
# In defaults/main.yml
optional_feature_enabled: false
optional_feature_requires_monitoring: true  # Needs monitoring

# In tasks/main.yml
- name: Verify monitoring is enabled
  fail:
    msg: "Monitoring must be enabled for optional feature"
  when: optional_feature_enabled and not monitoring_enabled
```

### 7. Update Documentation

Document optional feature:
- When to use it
- How to enable it
- Requirements and dependencies
- Configuration options

### 8. Update Test Scripts

Make test scripts handle optional features:
```bash
# Check if optional feature is enabled
if kubectl get daemonset optional-feature &> /dev/null; then
    echo "✓ Optional feature is enabled"
    # Test optional feature
else
    echo "○ Optional feature is not enabled (optional)"
fi
```

## Best Practices

- ✅ **False by Default**: For features needed by few users
- ✅ **True by Default**: For features needed by most users
- ✅ **Clear Documentation**: How to enable and configure
- ✅ **Dependency Checks**: Verify prerequisites if needed
- ✅ **Graceful Degradation**: System works without optional features
- ✅ **Easy Enablement**: Simple one-variable change
- ✅ **Test Coverage**: Test both enabled and disabled states

## Common Patterns

### GPU Monitoring Pattern

```yaml
# defaults/main.yml
nvidia_exporter_enabled: false  # Most clusters don't have GPU

# tasks/main.yml
- name: Create NVIDIA Exporter
  # ... tasks ...
  when: nvidia_exporter_enabled

# README.md
## GPU Monitoring (Optional)

To enable GPU monitoring:
1. Set `nvidia_exporter_enabled: true` in defaults/main.yml
2. Ensure NVIDIA drivers are installed on nodes
3. Re-run monitoring role
```

### Advanced Alerting Pattern

```yaml
# defaults/main.yml
alertmanager_enabled: true  # Most users want alerts
advanced_alerts_enabled: false  # Advanced rules optional

# tasks/main.yml
- name: Create basic alerts
  # ... always created ...

- name: Create advanced alerts
  # ... only if advanced_alerts_enabled ...
  when: advanced_alerts_enabled
```

## What NOT to Do

- ❌ Don't make optional features required for basic functionality
- ❌ Don't enable by default if most users don't need it
- ❌ Don't skip documentation on how to enable
- ❌ Don't forget to check dependencies
- ❌ Don't make enabling process complex
- ❌ Don't break basic functionality if optional feature fails

## Example Workflow

1. **Identify**: Feature as optional
2. **Add**: Feature flag to defaults/main.yml (false by default)
3. **Implement**: Feature with `when: feature_enabled`
4. **Document**: How to enable in README
5. **Test**: Both enabled and disabled states
6. **Update**: Test scripts to handle optional feature

## Example Implementation

### Feature Flag Definition

```yaml
# defaults/main.yml
---
# NVIDIA GPU Monitoring (Optional)
nvidia_exporter_enabled: false  # Disabled by default
nvidia_exporter_version: "v1.2.0"
nvidia_exporter_namespace: "monitoring"
```

### Conditional Implementation

```yaml
# tasks/main.yml
- name: Create NVIDIA Exporter DaemonSet
  copy:
    dest: /tmp/nvidia-exporter.yaml
    content: |
      # ... DaemonSet spec ...
  when: nvidia_exporter_enabled

- name: Apply NVIDIA Exporter
  command: kubectl apply -f /tmp/nvidia-exporter.yaml
  when: nvidia_exporter_enabled

- name: Wait for NVIDIA Exporter
  command: kubectl wait --for=condition=ready pod -l app=nvidia-exporter
  when: nvidia_exporter_enabled
```

### Documentation

```markdown
## NVIDIA GPU Monitoring (Optional)

### Enabling GPU Monitoring

If your cluster has GPU nodes, you can enable GPU metrics collection:

1. Edit `monitoring/defaults/main.yml`:
   ```yaml
   nvidia_exporter_enabled: true
   ```

2. Re-run monitoring setup:
   ```bash
   ansible-playbook -i inventory.yml site.yml --tags monitoring
   ```

3. Verify installation:
   ```bash
   kubectl get pods -n monitoring -l app=nvidia-exporter
   ```

### Requirements

- NVIDIA drivers installed on GPU nodes
- NVIDIA Container Runtime configured
- GPU nodes properly labeled

### Metrics Available

- GPU utilization
- GPU memory usage
- GPU temperature
- GPU power consumption
```

## References

- Feature Flags Best Practices: https://martinfowler.com/articles/feature-toggles.html
- Ansible Conditionals: https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html

