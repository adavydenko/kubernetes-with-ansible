name: edu-validate-code-examples
description: Validate syntax and functionality of all code examples, commands, and YAML manifests to ensure they work correctly. Use when creating documentation, tutorials, or any content with executable code.
---

# Validate Code Examples

Validate syntax and functionality of all code examples, commands, and YAML manifests to ensure they work correctly and are error-free.

## Primary intent

Verify executable code/commands/manifests embedded in educational or technical content.

## Use when

- Creating documentation with code examples
- Writing tutorials or guides
- Adding commands to educational materials
- User mentions "validate", "test", "check syntax", or "verify examples"
- Before finalizing any content with executable code

## Do NOT use when

- The issue is broken markdown/file links only
- The goal is generating an automated validation script from scratch
- The task is validating educational question quality
- The task is translation QA only

## Use other skills instead when

- Use `qa-validate-and-fix-links` for path/link integrity checks
- Use `qa-validation-script-generator` when a reusable script is requested
- Use `edu-educational-question-validator` for assessment-item quality validation

## Instructions

### 1. Identify All Code Examples

Find all executable content:
- `kubectl` commands
- YAML manifests (Deployments, Services, ConfigMaps, etc.)
- Ansible playbooks
- Bash scripts
- Docker commands
- Any other executable code

### 2. Check kubectl Commands

For each `kubectl` command, verify:
- **Labels**: Required labels are present (for selectors, NetworkPolicy, etc.)
- **Namespaces**: Namespace is specified if needed
- **Resources**: Resource requests/limits are included for scheduling
- **Syntax**: Command syntax is correct
- **Dependencies**: Required resources exist (namespaces, configs, etc.)

Common issues to fix:
```bash
# Missing namespace label
kubectl label namespace frontend kubernetes.io/metadata.name=frontend

# Missing resource requests/limits
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "200m"
    memory: "256Mi"

# Missing namespace in command
kubectl get pods -n <namespace>
```

### 3. Validate YAML Manifests

For YAML files, check:
- **Syntax**: Valid YAML syntax
- **Required fields**: All mandatory fields are present
- **API versions**: Correct API versions
- **Resource names**: Valid Kubernetes resource names
- **Selectors**: Match labels correctly
- **Dependencies**: Referenced resources exist

Common fixes:
```yaml
# Add missing labels for NetworkPolicy
metadata:
  labels:
    app: my-app
    kubernetes.io/metadata.name: my-namespace

# Add resource requests/limits
spec:
  containers:
  - name: app
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "500m"
        memory: "512Mi"
```

### 4. Check Ansible Playbooks

For Ansible content:
- **Syntax**: Valid YAML
- **Variables**: All variables are defined
- **Tasks**: Task syntax is correct
- **Dependencies**: Role dependencies are correct
- **Inventory**: Inventory structure is valid

### 5. Verify Bash Scripts

For shell scripts:
- **Syntax**: Valid bash syntax
- **Dependencies**: Required commands exist
- **Paths**: Paths are correct
- **Permissions**: Required permissions are noted

### 6. Test Dependencies

Ensure all dependencies are met:
- **Namespaces**: Created before use
- **ConfigMaps/Secrets**: Exist before referenced
- **StorageClasses**: Available before PVC creation
- **ServiceAccounts**: Created before RBAC bindings
- **NetworkPolicies**: Namespace labels exist

### 7. Validate Context

Check that examples work in context:
- **Order**: Commands are in correct order
- **Prerequisites**: Prerequisites are met
- **Environment**: Environment setup is documented
- **Expected output**: Expected results are clear

## Best Practices

- ✅ Test all commands before including
- ✅ Add missing required parameters (labels, resources, namespaces)
- ✅ Verify YAML syntax with validator
- ✅ Check dependencies between resources
- ✅ Ensure proper order of operations
- ✅ Document prerequisites clearly
- ✅ Include expected output/results

## Common Validation Patterns

### kubectl Commands

**Check for:**
- Namespace specification
- Label selectors
- Resource requirements
- Output format flags

**Fix:**
```bash
# Add namespace
kubectl get pods -n my-namespace

# Add labels
kubectl label namespace my-ns kubernetes.io/metadata.name=my-ns

# Add resource requirements
kubectl run test --image=nginx --requests=cpu=100m,memory=128Mi
```

### YAML Manifests

**Check for:**
- Required metadata fields
- Resource requests/limits
- Label selectors
- Namespace labels (for NetworkPolicy)

**Fix:**
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: test-ns
  labels:
    app: test
spec:
  containers:
  - name: app
    image: nginx
    resources:
      requests:
        cpu: "100m"
        memory: "128Mi"
      limits:
        cpu: "200m"
        memory: "256Mi"
```

### NetworkPolicy Requirements

**Always check:**
- Namespace labels exist
- Pod selectors match labels
- Policy rules are correct

**Fix:**
```bash
# Create namespace label first
kubectl label namespace my-ns kubernetes.io/metadata.name=my-ns

# Then create NetworkPolicy
kubectl apply -f network-policy.yaml
```

## Validation Checklist

For each code example:
- [ ] Syntax is correct
- [ ] All required parameters are present
- [ ] Dependencies are met
- [ ] Context is appropriate
- [ ] Expected output is documented
- [ ] Prerequisites are listed
- [ ] Commands are in correct order

## What NOT to Do

- ❌ Don't include untested commands
- ❌ Don't skip required parameters
- ❌ Don't ignore dependencies
- ❌ Don't forget namespace labels for NetworkPolicy
- ❌ Don't omit resource requests/limits for scheduling
- ❌ Don't use incorrect API versions

## Tools for Validation

### YAML Validators
- Online: yamlvalidator.com
- CLI: `yamllint`
- VS Code: YAML extension

### kubectl Validation
```bash
# Dry-run to validate
kubectl apply --dry-run=client -f manifest.yaml

# Validate syntax
kubectl explain <resource>
```

### Ansible Validation
```bash
# Check syntax
ansible-playbook --syntax-check playbook.yml

# Validate inventory
ansible-inventory --list -i inventory.yml
```

