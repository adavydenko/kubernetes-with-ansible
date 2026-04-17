name: k8s-solution-design-with-alternatives
description: Design solutions by proposing multiple alternatives with clear trade-offs and recommendations. Use when solving infrastructure problems, choosing between technologies, or when user needs to make informed decisions.
---

# Solution Design with Alternatives

Design solutions by researching and proposing multiple alternatives with clear advantages, limitations, and recommendations to help users make informed decisions.

## Primary intent

Compare viable solution options and recommend one with explicit trade-offs under user constraints.

## Use when

- User asks "what should I use for X?" or "how to solve Y?"
- Need to choose between multiple technologies or approaches
- User has constraints that require evaluating options
- Before implementing a solution that has alternatives
- User mentions "alternatives", "options", "which one", or "compare"

## Do NOT use when

- The goal is auditing current infrastructure for missing components
- The solution is already chosen and needs integration steps
- The task is specific implementation of monitoring stack manifests
- The task is a narrow optional-feature toggle inside an existing role

## Use other skills instead when

- Use `k8s-kubernetes-infrastructure-analysis` for gap/bottleneck audits
- Use `k8s-kubernetes-component-integration` for dependency wiring and rollout
- Use `k8s-monitoring-stack-setup` for end-to-end monitoring implementation

## Instructions

### 1. Understand the Problem

- Clearly define what problem needs to be solved
- Identify requirements and constraints:
  - Technical constraints (no external dependencies, limited resources)
  - Functional requirements (replication, performance, simplicity)
  - Operational requirements (ease of use, maintenance)
  - Scale requirements (10 nodes vs 1000 nodes)

### 2. Research Alternatives

Find 2-3 viable alternatives:
- Search for common solutions to the problem
- Consider different approaches (simple vs complex, local vs distributed)
- Look for solutions that match user constraints
- Check Kubernetes ecosystem for standard solutions

### 3. Analyze Each Alternative

For each alternative, document:

#### Advantages
- What it does well
- Key features
- When it's the best choice
- Strengths compared to others

#### Limitations
- What it doesn't do
- Known issues or constraints
- When it's not suitable
- Weaknesses compared to others

#### Implementation Complexity
- **Low**: Simple setup, minimal configuration
- **Medium**: Moderate setup, some configuration needed
- **High**: Complex setup, requires expertise

#### Infrastructure Requirements
- External dependencies (NFS, cloud services)
- Resource requirements (CPU, memory, disk)
- Network requirements
- Additional components needed

#### Operational Overhead
- Maintenance effort
- Monitoring needs
- Backup/disaster recovery complexity
- Upgrade complexity

### 4. Create Comparison Table

Create a clear comparison table:

```markdown
| Solution | Advantages | Limitations | Complexity | Best For |
|----------|------------|-------------|------------|---------|
| Option A | ... | ... | Low | Simple use cases |
| Option B | ... | ... | Medium | Balanced needs |
| Option C | ... | ... | High | Advanced requirements |
```

### 5. Provide Recommendation

Give a clear recommendation with justification:
- Which solution fits the user's constraints best
- Why this solution is recommended
- When to consider alternatives
- Migration path if needs change

### 6. Present to User

Structure the presentation:
1. **Problem Summary**: What we're solving
2. **Alternatives**: 2-3 options with full analysis
3. **Comparison**: Side-by-side comparison
4. **Recommendation**: Clear recommendation with reasoning
5. **Next Steps**: How to proceed with chosen solution

## Best Practices

- ✅ Always provide 2-3 alternatives (not just one)
- ✅ Be honest about limitations of each option
- ✅ Consider user constraints in recommendations
- ✅ Provide clear comparison table
- ✅ Give actionable recommendation
- ✅ Explain "why" not just "what"
- ✅ Consider future scalability needs

## Common Patterns

### Storage Solutions Comparison

```
Problem: Need persistent storage without external NFS

Alternatives:
1. Local Storage Provisioner
   - Advantages: Simple, fast, no deps
   - Limitations: No replication, node-bound
   - Best for: Simple clusters, stateless apps with local cache

2. OpenEBS
   - Advantages: Replicated, distributed
   - Limitations: More complex, resource intensive
   - Best for: Production, stateful apps needing replication

3. Longhorn
   - Advantages: Replicated, web UI, snapshots
   - Limitations: Most complex, requires more resources
   - Best for: Production with backup needs

Recommendation: Start with Local Storage, migrate to Longhorn if replication needed
```

### Monitoring Solutions Comparison

```
Problem: Need monitoring for Kubernetes cluster

Alternatives:
1. Prometheus + Grafana
   - Advantages: Standard, flexible, open source
   - Limitations: Requires setup and maintenance
   - Best for: Self-hosted, full control

2. Cloud Monitoring
   - Advantages: Managed, integrated
   - Limitations: Vendor lock-in, cost
   - Best for: Cloud deployments

Recommendation: Prometheus + Grafana for self-hosted clusters
```

## What NOT to Do

- ❌ Don't recommend only one solution without alternatives
- ❌ Don't hide limitations or trade-offs
- ❌ Don't recommend solutions that violate user constraints
- ❌ Don't over-engineer (recommend complex when simple works)
- ❌ Don't ignore operational complexity
- ❌ Don't make recommendations without understanding constraints

## Example Workflow

1. **Understand**: Problem and constraints
2. **Research**: Find 2-3 viable alternatives
3. **Analyze**: Advantages, limitations, complexity for each
4. **Compare**: Create comparison table
5. **Recommend**: Best fit with justification
6. **Present**: Structured presentation to user

## Example Output Format

```markdown
## Solution Design: Persistent Storage

### Problem
Need persistent storage for Kubernetes cluster without external NFS dependency.

### Alternatives

#### 1. Local Storage Provisioner
**Advantages:**
- Simple setup and configuration
- High performance (local disk access)
- No external dependencies
- Low resource overhead

**Limitations:**
- No data replication
- Data tied to specific node
- Data loss if node fails
- Cannot migrate between nodes

**Complexity:** Low
**Best For:** Development, simple production, stateless apps with local cache

#### 2. OpenEBS
**Advantages:**
- Data replication across nodes
- Distributed storage
- Kubernetes-native
- Good for stateful applications

**Limitations:**
- More complex setup
- Higher resource requirements
- Requires more nodes for replication
- Operational overhead

**Complexity:** Medium-High
**Best For:** Production clusters needing replication

#### 3. Longhorn
**Advantages:**
- Data replication with snapshots
- Web UI for management
- Backup capabilities
- Good documentation

**Limitations:**
- Most complex setup
- Highest resource requirements
- Requires stable network
- Learning curve

**Complexity:** High
**Best For:** Production with backup/disaster recovery needs

### Comparison

| Feature | Local Storage | OpenEBS | Longhorn |
|---------|--------------|---------|----------|
| Replication | ❌ | ✅ | ✅ |
| Simplicity | ✅✅✅ | ✅ | ✅ |
| Performance | ✅✅✅ | ✅✅ | ✅✅ |
| Backup | ❌ | ❌ | ✅ |
| Resource Usage | Low | Medium | High |

### Recommendation

**For 10-node cluster without external dependencies:**
Start with **Local Storage Provisioner** because:
- Matches constraint of no external dependencies
- Simple to implement and maintain
- Sufficient for most use cases
- Easy to migrate to Longhorn later if replication needed

**Migration Path:** Can add Longhorn later without losing Local Storage setup.
```

## References

- Kubernetes Storage: https://kubernetes.io/docs/concepts/storage/
- CNCF Landscape: https://landscape.cncf.io/
- Kubernetes Best Practices: https://kubernetes.io/docs/concepts/

