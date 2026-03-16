name: k8s-kubernetes-infrastructure-analysis
description: Analyze existing Kubernetes infrastructure to identify gaps, bottlenecks, and missing components. Use when user requests infrastructure analysis, before adding new components, or when planning cluster expansion.
---

# Kubernetes Infrastructure Analysis

Analyze existing Kubernetes infrastructure to identify critical gaps, bottlenecks, dependencies, and missing components that could impact cluster operations.

## When to Use

- User requests infrastructure analysis or gap analysis
- Before adding new components to the cluster
- When planning cluster expansion or scaling
- User mentions "bottlenecks", "missing components", "gaps", or "what's missing"
- After initial cluster setup to verify completeness

## Instructions

### 1. Understand Project Structure

- Read project README.md to understand overall architecture
- List all Ansible roles in `ansible/roles/`
- Review `ansible/playbooks/site.yml` to see execution order
- Check inventory file to understand cluster size and node types
- Identify existing components and their purposes

### 2. Analyze Core Kubernetes Components

Check for presence and configuration of:
- **Control Plane**: Master node setup (kube-apiserver, etcd, scheduler, controller-manager)
- **Worker Nodes**: Worker node configuration and joining process
- **CNI**: Network plugin (Flannel, Calico, etc.)
- **Container Runtime**: containerd, Docker, CRI-O

### 3. Identify Critical Infrastructure Gaps

Check for missing components in these categories:

#### Storage
- ❌ No StorageClass defined
- ❌ No PersistentVolume support
- ❌ No storage provisioner (Local Storage, NFS, Ceph, etc.)
- ❌ No backup/disaster recovery solution

#### Networking
- ❌ No LoadBalancer implementation (MetalLB, cloud LB)
- ❌ No Ingress controller
- ❌ No DNS resolution (CoreDNS should be default)
- ❌ No Network Policies

#### Monitoring & Observability
- ❌ No metrics collection (Prometheus, etc.)
- ❌ No visualization (Grafana, etc.)
- ❌ No log aggregation
- ❌ No alerting system
- ❌ No node metrics exporter

#### Security
- ❌ No RBAC configuration
- ❌ No Network Policies
- ❌ No secrets management
- ❌ No pod security policies

#### High Availability
- ❌ Single master node (no HA)
- ❌ No etcd backup
- ❌ No disaster recovery plan

### 4. Analyze Dependencies

Map dependencies between components:
- Which components depend on others?
- What's the correct installation order?
- Are there circular dependencies?
- What breaks if a component is missing?

### 5. Consider User Constraints

Identify and document user constraints:
- No external dependencies (NFS, cloud services)
- Limited resources (CPU, memory, disk)
- Specific requirements (GPU support, etc.)
- Budget constraints
- Compliance requirements

### 6. Prioritize Findings

Categorize findings by priority:
- **Critical**: Blocks basic functionality (e.g., no storage for stateful apps)
- **Important**: Needed for production use (e.g., monitoring, backups)
- **Nice to have**: Improves operations (e.g., advanced monitoring)

### 7. Provide Recommendations

For each gap, provide:
- **Problem**: What's missing and why it matters
- **Impact**: What functionality is blocked or limited
- **Solutions**: 2-3 alternative solutions with trade-offs
- **Priority**: Critical/Important/Nice to have
- **Complexity**: Low/Medium/High implementation effort

## Best Practices

- ✅ Start with core Kubernetes components, then infrastructure
- ✅ Consider user constraints before recommending solutions
- ✅ Provide multiple solution options with trade-offs
- ✅ Prioritize findings by impact and urgency
- ✅ Document dependencies between components
- ✅ Check for existing solutions before recommending new ones
- ✅ Consider cluster size when recommending solutions (10 nodes vs 100 nodes)

## Common Patterns

### Storage Analysis Pattern

```
1. Check for StorageClass: kubectl get storageclass
2. Check for PV/PVC support
3. Identify storage needs:
   - Stateful applications?
   - Database requirements?
   - Backup storage needs?
4. Recommend solutions based on constraints:
   - No NFS → Local Storage, OpenEBS, Longhorn
   - Need replication → OpenEBS, Longhorn
   - Simple start → Local Storage
```

### Monitoring Analysis Pattern

```
1. Check for metrics collection
2. Check for visualization tools
3. Check for alerting
4. Identify monitoring needs:
   - Node metrics?
   - Application metrics?
   - GPU metrics?
5. Recommend stack:
   - Prometheus + Grafana (standard)
   - Node Exporter (required for node metrics)
   - Optional: NVIDIA Exporter (if GPU present)
```

## What NOT to Do

- ❌ Don't recommend solutions that violate user constraints
- ❌ Don't assume external dependencies are available
- ❌ Don't skip dependency analysis
- ❌ Don't recommend over-engineered solutions for simple needs
- ❌ Don't ignore existing components that might solve the problem

## Example Workflow

1. **Read**: `README.md`, `ansible/playbooks/site.yml`, `ansible/roles/`
2. **List**: All existing components and their purposes
3. **Check**: For each critical category (storage, networking, monitoring)
4. **Identify**: Missing components and gaps
5. **Analyze**: Dependencies and constraints
6. **Prioritize**: Findings by impact
7. **Recommend**: Solutions with trade-offs
8. **Document**: Findings in structured format

## Example Output Format

```markdown
## Infrastructure Analysis Results

### Critical Gaps
1. **Storage System Missing**
   - Problem: No StorageClass or PersistentVolume support
   - Impact: Cannot deploy stateful applications
   - Solutions:
     - Local Storage Provisioner (simple, no external deps)
     - OpenEBS (replicated, more complex)
     - Longhorn (replicated with UI, most complex)
   - Priority: Critical
   - Complexity: Low (Local Storage) to High (Longhorn)

### Important Gaps
2. **Monitoring System Missing**
   - Problem: No metrics collection or visualization
   - Impact: Cannot monitor cluster health and performance
   - Solutions:
     - Prometheus + Grafana (standard stack)
     - Cloud monitoring (if cloud provider)
   - Priority: Important
   - Complexity: Medium
```

## References

- Kubernetes Components: https://kubernetes.io/docs/concepts/overview/components/
- Storage Classes: https://kubernetes.io/docs/concepts/storage/storage-classes/
- Monitoring: https://kubernetes.io/docs/tasks/debug-application-cluster/resource-usage-monitoring/

