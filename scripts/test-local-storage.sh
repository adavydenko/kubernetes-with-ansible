#!/bin/bash

# Local Storage Test Script
# Tests the Local Storage Provisioner functionality

set -e

echo "🔍 Testing Local Storage Configuration..."

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

# Check storage classes
echo -e "\n${YELLOW}Checking Storage Classes...${NC}"
if kubectl get storageclass &> /dev/null; then
    print_status 0 "Storage classes are available"
    kubectl get storageclass
else
    print_status 1 "No storage classes found"
fi

# Check for local-storage class specifically
if kubectl get storageclass local-storage &> /dev/null; then
    print_status 0 "local-storage class is configured"
else
    print_status 1 "local-storage class not found"
fi

# Check local-storage-system namespace
echo -e "\n${YELLOW}Checking Local Storage Namespace...${NC}"
if kubectl get namespace local-storage-system &> /dev/null; then
    print_status 0 "local-storage-system namespace exists"
    if kubectl get pods -n local-storage-system &> /dev/null; then
        print_status 0 "Local storage provisioner pods are running"
        kubectl get pods -n local-storage-system
    else
        print_status 1 "Local storage provisioner pods not found"
    fi
else
    print_status 1 "local-storage-system namespace not found"
fi

# Test creating a PVC
echo -e "\n${YELLOW}Testing PVC Creation...${NC}"

# Create a test PVC
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: local-test-pvc
  namespace: default
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 1Gi
EOF

# Wait for PVC to be bound
echo "Waiting for PVC to be bound..."
sleep 15

# Check PVC status
if kubectl get pvc local-test-pvc | grep -q "Bound"; then
    print_status 0 "Test PVC is bound successfully"
else
    print_status 1 "Test PVC is not bound"
    kubectl get pvc local-test-pvc
    kubectl describe pvc local-test-pvc
fi

# Test creating a pod with the PVC
echo -e "\n${YELLOW}Testing Pod with PVC...${NC}"

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: local-test-pod
  namespace: default
spec:
  containers:
  - name: test-container
    image: busybox
    command: ["/bin/sh", "-c", "echo 'Local storage test successful' > /data/test.txt && cat /data/test.txt && sleep 3600"]
    volumeMounts:
    - name: test-storage
      mountPath: /data
  volumes:
  - name: test-storage
    persistentVolumeClaim:
      claimName: local-test-pvc
  restartPolicy: Never
EOF

# Wait for pod to be ready
echo "Waiting for test pod to be ready..."
sleep 20

# Check pod status
if kubectl get pod local-test-pod | grep -q "Running"; then
    print_status 0 "Test pod is running successfully"
    
    # Check if the file was written
    if kubectl exec local-test-pod -- cat /data/test.txt 2>/dev/null | grep -q "Local storage test successful"; then
        print_status 0 "File write/read test successful"
    else
        print_status 1 "File write/read test failed"
    fi
else
    print_status 1 "Test pod is not running"
    kubectl describe pod local-test-pod
fi

# Test data persistence
echo -e "\n${YELLOW}Testing Data Persistence...${NC}"

# Delete and recreate the pod
kubectl delete pod local-test-pod --force --grace-period=0

cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: local-test-pod-2
  namespace: default
spec:
  containers:
  - name: test-container
    image: busybox
    command: ["/bin/sh", "-c", "cat /data/test.txt && echo 'Data persistence test successful'"]
    volumeMounts:
    - name: test-storage
      mountPath: /data
  volumes:
  - name: test-storage
    persistentVolumeClaim:
      claimName: local-test-pvc
  restartPolicy: Never
EOF

# Wait for pod to complete
echo "Waiting for persistence test to complete..."
sleep 15

# Check if data persisted
if kubectl logs local-test-pod-2 2>/dev/null | grep -q "Local storage test successful"; then
    print_status 0 "Data persistence test successful"
else
    print_status 1 "Data persistence test failed"
    kubectl logs local-test-pod-2
fi

# Cleanup
echo -e "\n${YELLOW}Cleaning up test resources...${NC}"
kubectl delete pod local-test-pod-2 --force --grace-period=0 2>/dev/null || true
kubectl delete pvc local-test-pvc 2>/dev/null || true
print_status 0 "Test resources cleaned up"

# Check PersistentVolumes
echo -e "\n${YELLOW}Checking PersistentVolumes...${NC}"
if kubectl get pv &> /dev/null; then
    print_status 0 "PersistentVolumes are available"
    kubectl get pv
else
    print_status 1 "No PersistentVolumes found"
fi

# Check all PVCs
echo -e "\n${YELLOW}Checking all PersistentVolumeClaims...${NC}"
if kubectl get pvc --all-namespaces &> /dev/null; then
    print_status 0 "PersistentVolumeClaims are available"
    kubectl get pvc --all-namespaces
else
    print_status 1 "No PersistentVolumeClaims found"
fi

echo -e "\n${GREEN}🎉 Local Storage test completed successfully!${NC}"

# Display storage usage information
echo -e "\n${YELLOW}Local Storage Summary:${NC}"
echo "Storage Classes:"
kubectl get storageclass -o wide

echo -e "\nPersistentVolumes:"
kubectl get pv -o wide

echo -e "\nPersistentVolumeClaims:"
kubectl get pvc --all-namespaces -o wide

echo -e "\n${YELLOW}Next steps:${NC}"
echo "1. Deploy the demo application: kubectl apply -f examples/local-storage-example.yml"
echo "2. Access the application: kubectl port-forward svc/storage-demo 8080:80"
echo "3. Open http://localhost:8080 in your browser"
