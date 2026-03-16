name: qa-validation-script-generator
description: Generate bash scripts for validating system configurations, checking component health, and diagnosing issues. Use when user needs automated validation, health checks, or diagnostic tools.
---

# Validation Script Generator

Create comprehensive bash scripts for validating configurations, checking system health, and diagnosing issues in technical environments.

## When to Use

- User requests validation or health check scripts
- Need automated configuration verification
- Creating diagnostic tools
- User mentions "validate", "check", "diagnose", "health check"
- Setting up CI/CD validation steps
- Troubleshooting system issues

## Instructions

### 1. Identify Validation Categories

Determine what needs validation:
- **Cluster Health**: Nodes, pods, services status
- **Component Status**: Specific components (GPU, networking, storage)
- **Configuration**: Config files, environment variables
- **Connectivity**: Network, DNS, API access
- **Resources**: CPU, memory, disk usage
- **Security**: RBAC, policies, certificates

### 2. Design Script Structure

Create modular script with:
- **Color-coded output**: Use colors for success/warning/error
- **Logging functions**: Standardized log_info, log_success, log_error
- **Modular checks**: Separate function for each validation
- **Error handling**: Proper exit codes and error messages
- **Report generation**: Optional report file output

### 3. Create Core Functions

Implement reusable functions:
```bash
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

check_dependencies() {
    # Check required tools
}

check_cluster_connection() {
    # Verify cluster access
}
```

### 4. Implement Validation Checks

For each category, create check functions:
- **Dependencies**: Verify required tools installed
- **Cluster**: Check kubectl access, node status
- **Components**: Validate specific components
- **Configuration**: Verify config files exist and valid
- **Connectivity**: Test network connections
- **Resources**: Check resource availability

### 5. Add Command-Line Interface

Support flexible invocation:
```bash
# Run all checks
./validation-script.sh all

# Run specific category
./validation-script.sh gpu
./validation-script.sh network
./validation-script.sh monitoring
```

### 6. Generate Reports

Optional report generation:
- Text file with timestamp
- JSON output for automation
- HTML report for sharing
- Summary statistics

### 7. Add Documentation

Include usage documentation:
- Command-line options
- Example outputs
- Troubleshooting tips
- Integration examples

## Best Practices

- ✅ Use color coding for quick visual feedback
- ✅ Modular functions for reusability
- ✅ Proper error handling and exit codes
- ✅ Support both interactive and automated use
- ✅ Generate actionable error messages
- ✅ Include dependency checks
- ✅ Make scripts idempotent when possible
- ✅ Document all functions and options

## Script Template Structure

```bash
#!/bin/bash
set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging functions
log_info() { echo -e "${BLUE}[INFO]${NC} $1"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
log_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Validation functions
check_dependencies() { ... }
check_cluster() { ... }
check_components() { ... }

# Main function
main() {
    check_dependencies
    check_cluster
    # ... other checks
}

# CLI handling
case "${1:-all}" in
    "all") main ;;
    "cluster") check_cluster ;;
    *) echo "Usage: $0 [all|cluster|...]" ;;
esac
```

## Common Validation Patterns

### Kubernetes Cluster
```bash
check_cluster_connection() {
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Cannot connect to cluster"
        return 1
    fi
    log_success "Cluster connection OK"
}
```

### Component Health
```bash
check_component() {
    local component=$1
    if kubectl get pods -n kube-system | grep -q "$component"; then
        log_success "$component is running"
    else
        log_error "$component not found"
    fi
}
```

### Configuration Validation
```bash
check_config_file() {
    local file=$1
    if [ -f "$file" ]; then
        if yamllint "$file" &> /dev/null; then
            log_success "$file is valid"
        else
            log_error "$file has syntax errors"
        fi
    else
        log_error "$file not found"
    fi
}
```

## What NOT to Do

- ❌ Don't create monolithic scripts - use functions
- ❌ Don't skip error handling
- ❌ Don't forget to check dependencies first
- ❌ Don't use unclear error messages
- ❌ Don't ignore exit codes
- ❌ Don't create scripts that modify system state unexpectedly

## Example Workflow

1. **Analyze**: Identify what needs validation
2. **Design**: Plan script structure and functions
3. **Implement**: Create validation functions
4. **Test**: Run script in various scenarios
5. **Document**: Add usage instructions
6. **Integrate**: Add to CI/CD or automation

## Related Skills

- `doc-technical-documentation-structure` - Document script usage
- `qa-error-handling-generation` - Handle script errors gracefully

