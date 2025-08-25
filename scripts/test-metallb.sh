#!/bin/bash

# MetalLB Test Script
# This script tests MetalLB functionality in your Kubernetes cluster

set -e

echo "=== MetalLB Test Script ==="
echo "Testing MetalLB installation and functionality..."
echo

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
    else
        echo -e "${RED}✗ $2${NC}"
        return 1
    fi
}

# Function to check if kubectl is available
check_kubectl() {
    if command -v kubectl &> /dev/null; then
        print_status 0 "kubectl is available"
    else
        print_status 1 "kubectl is not available"
        exit 1
    fi
}

# Function to check MetalLB namespace
check_metallb_namespace() {
    if kubectl get namespace metallb-system &> /dev/null; then
        print_status 0 "MetalLB namespace exists"
    else
        print_status 1 "MetalLB namespace does not exist"
        return 1
    fi
}

# Function to check MetalLB pods
check_metallb_pods() {
    echo "Checking MetalLB pods..."
    if kubectl get pods -n metallb-system --no-headers | grep -q "Running"; then
        print_status 0 "MetalLB pods are running"
        kubectl get pods -n metallb-system
    else
        print_status 1 "MetalLB pods are not running"
        kubectl get pods -n metallb-system
        return 1
    fi
}

# Function to check IP address pools
check_ip_pools() {
    echo "Checking IP address pools..."
    if kubectl get ipaddresspools -n metallb-system &> /dev/null; then
        print_status 0 "IP address pools configured"
        kubectl get ipaddresspools -n metallb-system
    else
        print_status 1 "IP address pools not configured"
        return 1
    fi
}

# Function to check L2 advertisements
check_l2_advertisements() {
    echo "Checking L2 advertisements..."
    if kubectl get l2advertisements -n metallb-system &> /dev/null; then
        print_status 0 "L2 advertisements configured"
        kubectl get l2advertisements -n metallb-system
    else
        print_status 1 "L2 advertisements not configured"
        return 1
    fi
}

# Function to deploy test application
deploy_test_app() {
    echo "Deploying test application..."
    
    # Create test deployment
    kubectl create deployment nginx-test --image=nginx --replicas=2 --dry-run=client -o yaml | kubectl apply -f -
    
    # Create LoadBalancer service
    kubectl expose deployment nginx-test --port=80 --type=LoadBalancer --dry-run=client -o yaml | kubectl apply -f -
    
    print_status 0 "Test application deployed"
}

# Function to wait for external IP
wait_for_external_ip() {
    echo "Waiting for external IP assignment..."
    
    local max_attempts=30
    local attempt=1
    
    while [ $attempt -le $max_attempts ]; do
        external_ip=$(kubectl get service nginx-test -o jsonpath='{.status.loadBalancer.ingress[0].ip}' 2>/dev/null)
        
        if [ -n "$external_ip" ]; then
            print_status 0 "External IP assigned: $external_ip"
            return 0
        fi
        
        echo -e "${YELLOW}Attempt $attempt/$max_attempts: Waiting for external IP...${NC}"
        sleep 10
        ((attempt++))
    done
    
    print_status 1 "Failed to get external IP after $max_attempts attempts"
    return 1
}

# Function to test connectivity
test_connectivity() {
    local external_ip=$1
    
    echo "Testing connectivity to $external_ip..."
    
    # Wait a bit for the service to be fully ready
    sleep 5
    
    # Test HTTP connectivity
    if curl -s --max-time 10 "http://$external_ip" | grep -q "nginx"; then
        print_status 0 "HTTP connectivity test passed"
    else
        print_status 1 "HTTP connectivity test failed"
        return 1
    fi
}

# Function to clean up test resources
cleanup_test() {
    echo "Cleaning up test resources..."
    
    kubectl delete service nginx-test --ignore-not-found=true
    kubectl delete deployment nginx-test --ignore-not-found=true
    
    print_status 0 "Test resources cleaned up"
}

# Function to show MetalLB status
show_metallb_status() {
    echo
    echo "=== MetalLB Status ==="
    echo "Pods:"
    kubectl get pods -n metallb-system
    echo
    echo "IP Address Pools:"
    kubectl get ipaddresspools -n metallb-system
    echo
    echo "L2 Advertisements:"
    kubectl get l2advertisements -n metallb-system
    echo
    echo "Services with LoadBalancer type:"
    kubectl get services --all-namespaces | grep LoadBalancer || echo "No LoadBalancer services found"
}

# Main execution
main() {
    echo "Starting MetalLB tests..."
    echo
    
    # Check prerequisites
    check_kubectl
    
    # Check MetalLB installation
    check_metallb_namespace
    check_metallb_pods
    check_ip_pools
    check_l2_advertisements
    
    echo
    echo "=== Testing LoadBalancer functionality ==="
    
    # Deploy and test application
    deploy_test_app
    wait_for_external_ip
    
    if [ $? -eq 0 ]; then
        external_ip=$(kubectl get service nginx-test -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
        test_connectivity "$external_ip"
    fi
    
    # Show final status
    show_metallb_status
    
    # Cleanup
    cleanup_test
    
    echo
    echo "=== Test completed ==="
}

# Run main function
main "$@"
