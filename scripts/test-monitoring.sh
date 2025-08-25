#!/bin/bash

# Monitoring Test Script
# Tests the Prometheus + Grafana monitoring system

set -e

echo "🔍 Testing Monitoring System..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $2"
    else
        echo -e "${RED}✗${NC} $2"
        exit 1
    fi
}

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo -e "${RED}✗ kubectl is not installed or not in PATH${NC}"
    exit 1
fi
print_status 0 "kubectl is available"

# Check if we can connect to the cluster
if ! kubectl cluster-info &> /dev/null; then
    echo -e "${RED}✗ Cannot connect to Kubernetes cluster${NC}"
    exit 1
fi
print_status 0 "Connected to Kubernetes cluster"

# Check monitoring namespace
echo -e "\n${YELLOW}Checking Monitoring Namespace...${NC}"
if kubectl get namespace monitoring &> /dev/null; then
    print_status 0 "monitoring namespace exists"
else
    print_status 1 "monitoring namespace not found"
fi

# Check monitoring pods
echo -e "\n${YELLOW}Checking Monitoring Pods...${NC}"
if kubectl get pods -n monitoring &> /dev/null; then
    print_status 0 "Monitoring pods are available"
    kubectl get pods -n monitoring
else
    print_status 1 "No monitoring pods found"
fi

# Check Prometheus
echo -e "\n${YELLOW}Checking Prometheus...${NC}"
if kubectl get deployment prometheus -n monitoring &> /dev/null; then
    print_status 0 "Prometheus deployment exists"
    
    # Check if Prometheus pod is running
    if kubectl get pods -n monitoring -l app=prometheus | grep -q "Running"; then
        print_status 0 "Prometheus pod is running"
    else
        print_status 1 "Prometheus pod is not running"
    fi
else
    print_status 1 "Prometheus deployment not found"
fi

# Check Grafana
echo -e "\n${YELLOW}Checking Grafana...${NC}"
if kubectl get deployment grafana -n monitoring &> /dev/null; then
    print_status 0 "Grafana deployment exists"
    
    # Check if Grafana pod is running
    if kubectl get pods -n monitoring -l app=grafana | grep -q "Running"; then
        print_status 0 "Grafana pod is running"
    else
        print_status 1 "Grafana pod is not running"
    fi
else
    print_status 1 "Grafana deployment not found"
fi

# Check Node Exporter
echo -e "\n${YELLOW}Checking Node Exporter...${NC}"
if kubectl get daemonset node-exporter -n monitoring &> /dev/null; then
    print_status 0 "Node Exporter DaemonSet exists"
    
    # Check if Node Exporter pods are running
    NODE_COUNT=$(kubectl get nodes --no-headers | wc -l)
    NODE_EXPORTER_COUNT=$(kubectl get pods -n monitoring -l app=node-exporter --no-headers | grep Running | wc -l)
    
    if [ "$NODE_EXPORTER_COUNT" -eq "$NODE_COUNT" ]; then
        print_status 0 "Node Exporter pods are running on all nodes ($NODE_EXPORTER_COUNT/$NODE_COUNT)"
    else
        print_status 1 "Node Exporter pods are not running on all nodes ($NODE_EXPORTER_COUNT/$NODE_COUNT)"
    fi
else
    print_status 1 "Node Exporter DaemonSet not found"
fi

# Check NVIDIA Node Exporter
echo -e "\n${YELLOW}Checking NVIDIA Node Exporter...${NC}"
if kubectl get daemonset nvidia-exporter -n monitoring &> /dev/null; then
    print_status 0 "NVIDIA Node Exporter DaemonSet exists"
    
    # Check if NVIDIA Exporter pods are running
    NVIDIA_EXPORTER_COUNT=$(kubectl get pods -n monitoring -l app=nvidia-exporter --no-headers | grep Running | wc -l)
    
    if [ "$NVIDIA_EXPORTER_COUNT" -gt 0 ]; then
        print_status 0 "NVIDIA Node Exporter pods are running ($NVIDIA_EXPORTER_COUNT pods)"
    else
        print_status 1 "NVIDIA Node Exporter pods are not running"
    fi
else
    print_status 0 "NVIDIA Node Exporter DaemonSet not found (GPU monitoring not enabled)"
fi

# Check services
echo -e "\n${YELLOW}Checking Monitoring Services...${NC}"
if kubectl get svc -n monitoring &> /dev/null; then
    print_status 0 "Monitoring services are available"
    kubectl get svc -n monitoring
else
    print_status 1 "No monitoring services found"
fi

# Check PVCs
echo -e "\n${YELLOW}Checking Monitoring PVCs...${NC}"
if kubectl get pvc -n monitoring &> /dev/null; then
    print_status 0 "Monitoring PVCs are available"
    kubectl get pvc -n monitoring
else
    print_status 1 "No monitoring PVCs found"
fi

# Test Prometheus connectivity
echo -e "\n${YELLOW}Testing Prometheus Connectivity...${NC}"
if kubectl get svc prometheus -n monitoring &> /dev/null; then
    print_status 0 "Prometheus service exists"
    
    # Test if Prometheus is responding
    if kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://localhost:9090/api/v1/query?query=up &> /dev/null; then
        print_status 0 "Prometheus API is responding"
    else
        print_status 1 "Prometheus API is not responding"
    fi
else
    print_status 1 "Prometheus service not found"
fi

# Test Grafana connectivity
echo -e "\n${YELLOW}Testing Grafana Connectivity...${NC}"
if kubectl get svc grafana -n monitoring &> /dev/null; then
    print_status 0 "Grafana service exists"
    
    # Test if Grafana is responding
    if kubectl exec -n monitoring deployment/grafana -- wget -qO- http://localhost:3000/api/health &> /dev/null; then
        print_status 0 "Grafana API is responding"
    else
        print_status 1 "Grafana API is not responding"
    fi
else
    print_status 1 "Grafana service not found"
fi

# Test Node Exporter metrics
echo -e "\n${YELLOW}Testing Node Exporter Metrics...${NC}"
if kubectl get svc node-exporter -n monitoring &> /dev/null; then
    print_status 0 "Node Exporter service exists"
    
    # Test if Node Exporter is providing metrics
    if kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://node-exporter.monitoring.svc.cluster.local:9100/metrics | grep -q "node_cpu_seconds_total"; then
        print_status 0 "Node Exporter is providing metrics"
    else
        print_status 1 "Node Exporter is not providing metrics"
    fi
else
    print_status 1 "Node Exporter service not found"
fi

# Test NVIDIA Node Exporter metrics
echo -e "\n${YELLOW}Testing NVIDIA Node Exporter Metrics...${NC}"
if kubectl get svc nvidia-exporter -n monitoring &> /dev/null; then
    print_status 0 "NVIDIA Node Exporter service exists"
    
    # Test if NVIDIA Exporter is providing metrics
    if kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://nvidia-exporter.monitoring.svc.cluster.local:9400/metrics | grep -q "DCGM_FI_DEV_GPU_UTIL"; then
        print_status 0 "NVIDIA Node Exporter is providing GPU metrics"
    else
        print_status 1 "NVIDIA Node Exporter is not providing GPU metrics"
    fi
else
    print_status 0 "NVIDIA Node Exporter service not found (GPU monitoring not enabled)"
fi

# Check Prometheus targets
echo -e "\n${YELLOW}Checking Prometheus Targets...${NC}"
if kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://localhost:9090/api/v1/targets | grep -q "node-exporter"; then
    print_status 0 "Node Exporter target is configured in Prometheus"
else
    print_status 1 "Node Exporter target is not configured in Prometheus"
fi

# Display monitoring summary
echo -e "\n${GREEN}🎉 Monitoring test completed successfully!${NC}"

echo -e "\n${YELLOW}Monitoring System Summary:${NC}"
echo "Namespace: monitoring"
echo "Prometheus: $(kubectl get pods -n monitoring -l app=prometheus --no-headers | grep Running | wc -l)/1"
echo "Grafana: $(kubectl get pods -n monitoring -l app=grafana --no-headers | grep Running | wc -l)/1"
echo "Node Exporter: $(kubectl get pods -n monitoring -l app=node-exporter --no-headers | grep Running | wc -l)/$(kubectl get nodes --no-headers | wc -l)"
echo "NVIDIA Exporter: $(kubectl get pods -n monitoring -l app=nvidia-exporter --no-headers | grep Running | wc -l) pods"

echo -e "\n${YELLOW}Access Information:${NC}"
echo "Prometheus: kubectl port-forward -n monitoring svc/prometheus 9090:9090"
echo "Grafana: kubectl port-forward -n monitoring svc/grafana 3000:3000"
echo "Grafana Login: admin / admin123"

echo -e "\n${YELLOW}Useful Commands:${NC}"
echo "Check monitoring pods: kubectl get pods -n monitoring"
echo "Check monitoring services: kubectl get svc -n monitoring"
echo "Check monitoring PVCs: kubectl get pvc -n monitoring"
echo "Prometheus logs: kubectl logs -n monitoring deployment/prometheus"
echo "Grafana logs: kubectl logs -n monitoring deployment/grafana"
echo "Node Exporter logs: kubectl logs -n monitoring daemonset/node-exporter"

echo -e "\n${YELLOW}Next Steps:${NC}"
echo "1. Access Grafana and add Prometheus as data source"
echo "2. Import Kubernetes dashboards"
echo "3. Configure alerts"
echo "4. Set up external access if needed"
