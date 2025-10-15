Kubernetes Master Role
======================

This Ansible role configures a Kubernetes control plane node using kubeadm and containerd as the container runtime.

Requirements
------------

- Ubuntu/Debian-based systems
- Root or sudo access
- Internet connectivity for downloading packages and container images
- At least 2GB RAM and 2 CPU cores

Role Variables
--------------

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Kubernetes version and repository
k8s_version: "1.31"
k8s_repo_url: "https://pkgs.k8s.io/core:/stable:/v{{ k8s_version }}/deb/"

# Networking configuration
pod_network_cidr: "10.244.0.0/16"

# Firewall control
use_ufw: false

# Network plugin selection
network_plugin: "flannel"
```

Dependencies
------------

This role is self-contained and handles all Kubernetes master node setup.

Example Playbook
----------------

```yaml
- hosts: k8s_masters
  become: true
  roles:
    - kubernetes_master
```

With custom variables:

```yaml
- hosts: k8s_masters
  become: true
  roles:
    - role: kubernetes_master
      vars:
        k8s_version: "1.30"
        pod_network_cidr: "10.244.0.0/16"
        network_plugin: "calico"
```

What This Role Does
-------------------

1. **System Preparation**:
   - Installs required packages (curl, gnupg2, apt-transport-https, ca-certificates)
   - Disables swap
   - Configures kernel modules for containerd

2. **Container Runtime Setup**:
   - Configures containerd with systemd cgroup driver
   - Sets up kernel parameters for Kubernetes

3. **Firewall Configuration**:
   - Opens required ports for Kubernetes API server, etcd, and kubelet

4. **Kubernetes Installation**:
   - Adds Kubernetes repository
   - Installs kubeadm, kubelet, kubectl
   - Holds packages to prevent automatic updates

5. **Cluster Initialization**:
   - Initializes Kubernetes control plane with kubeadm
   - Generates join command for worker nodes
   - Sets up admin configuration

License
-------

MIT

Author Information
------------------

Aleksandr A. Davydenko
