Kubernetes Network Role
=======================

This Ansible role configures cluster networking for Kubernetes using Flannel CNI plugin.

Requirements
------------

- Kubernetes cluster must be initialized (kubeadm init completed)
- kubectl must be available and configured
- KUBECONFIG environment variable must point to admin.conf

What this role does
-------------------

1. Installs Flannel network plugin using kubectl apply
2. Removes taint from master node to allow workload scheduling

Role Variables
--------------

This role does not require any variables to be set.

Dependencies
------------

- kubernetes_master role (must be executed first)

Example Playbook
----------------

```yaml
- name: Configure kubernetes network
  hosts: master_nodes
  become: true
  roles:
    - kubernetes_network
```

License
-------

MIT

Author Information
------------------

Aleksandr A. Davydenko
