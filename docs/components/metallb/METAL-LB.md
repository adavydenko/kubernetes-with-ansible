# Intro

**MetalLB** is a solid choice for adding load balancer functionality to a bare metal (non-cloud) Kubernetes cluster. Below are the steps and an Ansible playbook to automate MetalLB installation and configuration.

---

# How to install?

## 1. **Prerequisites**

- Kubernetes cluster (which you already have).
- `kubectl` working and configured.
- Ansible installed on your jump/management machine.
- You need to know a pool of spare IPs from your network for MetalLB to allocate (for Services of type `LoadBalancer`).  
  _(E.g., your nodes are on 192.168.1.100-103, you can assign 192.168.1.200-210 for MetalLB.)_


## 2. **Manual Installation Steps**

1. **Install MetalLB:**
   ```sh
   kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.14.5/config/manifests/metallb-native.yaml
   ```

2. **Create a ConfigMap for Layer 2 configuration (example IP range 192.168.1.200-210):**
   ```yaml
   apiVersion: metallb.io/v1beta1
   kind: IPAddressPool
   metadata:
     namespace: metallb-system
     name: default-address-pool
   spec:
     addresses:
     - 192.168.1.200-192.168.1.210

   ---
   apiVersion: metallb.io/v1beta1
   kind: L2Advertisement
   metadata:
     namespace: metallb-system
   ```

   Save this as `metallb-config.yaml` and apply:
   ```sh
   kubectl apply -f metallb-config.yaml
   ```


## 3. **Automated Installation with Ansible**

Suppose you have `kubectl` working _locally_ and your `kubeconfig` is accessible.

### **Ansible Playbook: `metallb_install.yml`**

```yaml
---
- name: Install MetalLB on Kubernetes
  hosts: localhost
  gather_facts: no
  vars:
    metallb_namespace: metallb-system
    metallb_version: v0.14.5
    metallb_pool_start: "192.168.1.200"
    metallb_pool_end: "192.168.1.210"

  tasks:
    - name: Deploy MetalLB manifests
      ansible.builtin.shell: |
        kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/{{ metallb_version }}/config/manifests/metallb-native.yaml
      args:
        warn: false

    - name: Wait for MetalLB controller deployment to be ready
      community.kubernetes.k8s_info:
        kind: Deployment
        namespace: "{{ metallb_namespace }}"
        name: controller
      register: controller_info
      until: controller_info.resources[0].status.readyReplicas >= 1
      retries: 10
      delay: 10

    - name: Create MetalLB address pool and Layer2 advertisement ConfigMap
      ansible.builtin.copy:
        dest: /tmp/metallb-config.yaml
        content: |
          apiVersion: metallb.io/v1beta1
          kind: IPAddressPool
          metadata:
            namespace: {{ metallb_namespace }}
            name: default-address-pool
          spec:
            addresses:
            - {{ metallb_pool_start }}-{{ metallb_pool_end }}

          ---
          apiVersion: metallb.io/v1beta1
          kind: L2Advertisement
          metadata:
            namespace: {{ metallb_namespace }}

    - name: Apply MetalLB Config
      ansible.builtin.shell: kubectl apply -f /tmp/metallb-config.yaml
      args:
        warn: false
```

### **How to Use:**

1. Save the playbook above as `metallb_install.yml`.
2. Adjust `metallb_pool_start` and `metallb_pool_end` variables as needed.
3. Make sure you have Ansible’s **kubernetes.core** and **community.kubernetes** collections installed:
   ```
   ansible-galaxy collection install community.kubernetes
   ```
4. Run:
   ```
   ansible-playbook metallb_install.yml
   ```

# How to test?

Here is a practical step-by-step guide for validating your MetalLB (BGP or L2) Kubernetes installation.
This starts with basic health checks and proceeds all the way to verifying end-to-end load balancer IP reachability.

## **Step 1: Verify MetalLB Controller and Speaker are Running**

Check that MetalLB’s controller and speaker pods are running in the `metallb-system` namespace:

```sh
kubectl get pods -n metallb-system
```
**Expect:**  
- 1 controller pod (Running)
- 1 speaker pod per node (Running)

Example:
```
NAME                          READY   STATUS    RESTARTS   AGE
controller-...                1/1     Running   0          5m
speaker-xxxxx                 1/1     Running   0          5m
speaker-yyyyy                 1/1     Running   0          5m
speaker-zzzzz                 1/1     Running   0          5m
...

## **Step 2: Check MetalLB ConfigMap/Custom Resource**

Check that your address pool and L2Advertisement exist.

```sh
kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system
kubectl describe ipaddresspool -n metallb-system
kubectl describe l2advertisement -n metallb-system
```
**Expect:**  
- Pool and advertisement exist, with correct IP address range.

---

## **Step 3: Deploy a Test Application**

Let’s use nginx as an example test deployment.

```sh
kubectl create deployment nginx --image=nginx --port=80
kubectl expose deployment nginx --port=80 --type=LoadBalancer
```

**This will create a Service of type LoadBalancer that MetalLB should assign an external IP from your pool.**


## **Step 4: Watch Service for External IP Assignment**

```sh
kubectl get svc nginx
```
**Example output:**
```
NAME    TYPE           CLUSTER-IP      EXTERNAL-IP     PORT(S)        AGE
nginx   LoadBalancer   10.96.53.142    192.168.1.200   80:30700/TCP   1m
```
**Expect:**  
- The **EXTERNAL-IP** should be **from the pool** you configured for MetalLB.
- If it stays in “pending” state, check MetalLB logs/config.


## **Step 5: Test External IP from Your Network**

On a host in the same subnet as your cluster, test:

```sh
curl http://192.168.1.200/
```
(or whatever EXTERNAL-IP your service shows)

**Expect:**  
- Default nginx welcome page HTML.


## **Step 6: (Optional) Advanced Validation**

### **A. Check ARP Entry on Your LAN Host**

On a client machine (e.g. Linux/macOS/Windows) on the LAN, after a curl or ping, run:

```sh
arp -a | grep 192.168.1.200
```
or
```sh
ip neighbor | grep 192.168.1.200
```
**Expect:**  
- Shows the MAC address **of one of your cluster nodes** for the LB IP.

### **B. Test Pod-to-Pod Connectivity from Other Nodes**

From another node (or any LAN host):

```sh
curl http://192.168.1.200/
```
Should still work.

### **C. Failover test**

- Delete the MetalLB speaker pod running on the node “owning” the LB IP:
  ```sh
  kubectl delete pod -l app=metallb,speaker -n metallb-system --field-selector spec.nodeName=<current-owner>
  ```
- Retry your curl: MetalLB should quickly move ownership to another node, and the service should continue uninterrupted.


## **Step 6. Advanced: BGP Validation (optional)**

If running **BGP mode**:

### **A. Check BGP Peering**

- Go to your router and check its BGP status:
  - For example, if you use FRR or VyOS:
    ```sh
    show ip bgp summary
    ```
  - On Cisco/Juniper/Fortigate, use their BGP show commands.

**You want to see the Kubernetes nodes peered and “Established”.**  
Check that the router has learned the `/32` host routes for each MetalLB-assigned IP.

### **B. Check Routing on Router**

```sh
show ip route 192.168.1.200
```
You should see that the route for that IP points back to one of your Kubernetes node’s IPs.

### **C. Test failover**

- Drain a node or delete the speaker pod on the owning node.
- Watch on your router: the BGP route should be withdrawn and re-announced from another node.
- Test that after failover, the service is still available at the same LoadBalancer IP.

## **Step 7: Troubleshooting if Not Working**

### **A. Service stuck as “pending”?**
  - Check MetalLB controller and speaker logs:
    ```sh
    kubectl logs -n metallb-system deployment/controller
    kubectl logs -n metallb-system daemonset/speaker
    ```
  - Double-check IP pool in your MetalLB config.
  - Make sure **no device or DHCP server is using/conflicting with the pool**.

### **B. Check MetalLB Logs**
```sh
kubectl logs -n metallb-system deployment/controller
# For Speaker (on a given node)
kubectl logs -n metallb-system daemonset/speaker -c speaker
```

### **C. Confirm that the Service Endpoints are Populated:**
```sh
kubectl get endpoints nginx
kubectl describe svc nginx
```

### **D. If Service doesn’t get IP or isn’t reachable…**
- Check for IP overlaps.
- Validate speaker pods are Running on all nodes.
- Confirm ARP resolution is showing a cluster node's MAC for the LB IP.
- Check for BGP issues (router logs, firewall issues on TCP 179).
- Confirm cluster nodes are reachable from LAN.
- Try from different LAN hosts.


## **Summary Table**

# **Example of the Whole Process (Copy-paste Ready)**

```sh
# 1. Health check
kubectl get pods -n metallb-system

# 2. Inspect CRs
kubectl get all -n metallb-system
kubectl describe ipaddresspool -n metallb-system

# 3. Deploy and expose nginx
kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer

# 4. See assigned IP
kubectl get svc nginx

# 5. Test from LAN (replace IP!)
curl http://<external-lb-ip>/
```


| Step                     | Command/example                            | Success Criteria                           |
|--------------------------|--------------------------------------------|--------------------------------------------|
| MetalLB pods healthy     | `kubectl get pods -n metallb-system`       | All controller & speaker pods Running      |
| Check pool/advertisement | `kubectl get ipaddresspools -n metallb-system` | Shows correct pool/advertisement         |
| Deploy & expose app      | as above                                   | `kubectl get svc nginx` shows EXTERNAL-IP  |
| Test external access     | `curl http://<LB-IP>`                      | nginx page loads from your LAN             |
| Check ARP on LAN         | `arp -a` or `ip neighbor`                  | MAC points to node’s interface             |
| Failover                 | delete speaker pod                         | Service still reachable at same LB-IP      |

**This validates that MetalLB L2 mode is functioning: assigning IPs, ARP-ing for them, and delivering traffic!**

