## K8s Cluster Setup

Для организации кластера используем:
* VirtualBox - для хостинга виртуальных машин
* Ubuntu server 24 (LTS) - как базовый образ для нод кластера
* Ubuntu Desktop 24.10 - как базовый образ управляющей машины
* Ansible - для автоматизации процесса раскатки конфигураций на Виртуальные Машины

![alt text](<.imgs/cluster-setup.png>)

### Настройка окружений
Мы будем создавать 2 группы ресурсов:
1. Управляющий контур (control нова)
2. K8s контур (мастер и рабочие ноды кубернетес кластера)

Control ответственен за настройку всех узлов k8s кластера и организации самого кластера.

### VMs
Следующие виртуальные машины будут созданы для организации кластера:

| Узел           | IP адрес  | Описание                                                                                                                                                                             |
|----------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| control        | 10.0.2.15 | Управляющая ВМ, с этой машины будут запускаться ansible скрипты и раскатываться на остальные машины.  При это необходимо, чтобы с этой машины был ssh доступ до всех остальных машин |
| kube-master    | 10.0.2.5  | master-нода k8s кластера                                                                                                                                                             |
| kube-worker-01 | 10.0.2.6  | Ноды исполняющие рабочую нагрузку на кластере                                                                                                                                        |
| kube-worker-02 | 10.0.2.7  |                                                                                                                                                                                      |
| ...            | ...       | ...                                                                                                                                                                                  |
|                |           |                                                                                                                                                                                      |


(!) необходимо заменить ip адреса на фактические адреса внутри сети


### Prerequisites (nodes)
Перед началом установки необходимо убедиться, что выполнены следующие шаги:
- [ ] На kube-* Установлена Ubuntu Server 24 с единого дистрибутива, варианты:https://cdimage.ubuntu.com/ubuntu-server/daily-live/pending/ (на момент заметки это 24.10 Oracular Oriole)https://ubuntu.com/download/server (24.04.01 LTS)
- [ ] Необходимо обновить все экземпляры/ноды:
``` shell
sudo apt update -y && sudo apt upgrade -y
```
- [ ] Убедиться, что ssh включен и работает
``` shell
sudo apt install openssh-server
```
- [ ] А порт 22 открыт
``` shell
ss -tulpn | grep 22
```
- [ ] На всех ножах заведен пользователь с правами администратора, от имени которого будут устанавливаться ssh соединения и производиться настройка:
>

### Prerequisites (Ansible host)
Установка кластера будет производиться с помощью инструмента Ansible. Для этого необходимо выделить отдельную ноду вне кластера, с которой будет производиться установка

- [ ] First, update your package lists and install Ansible on your control node only:
``` shell
sudo apt install ansible -y
```
- [ ] Next, set up SSH keys to allow passwordless access to your nodes. Generate an SSH key pair if you haven’t already:
``` shell
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```
- [ ] Now that you’ve created a public key on your control node, copy that key to each of your nodes:
``` shell
ssh-copy-id your_privileged_user@your_master_node_ip_address
ssh-copy-id your_privileged_user@your_worker_node_ip_address
```


## Ansible roles
Для каждого вида автоматизируемого ресурса создаем отдельную роль. Эта роль агрегируют задачи, которые будут запускаться на соответствующиих хостах

### kubernetes_master
### kubernetes_worker
### kubernetes_network


## GPU nodes support
NVidia provides support for cuda playbooks: https://github.com/NVIDIA/ansible-role-nvidia-driver

### 1. install cuda ansible playbook
> ansible-galaxy install nvidia.nvidia_driver
> ansible-playbook -i inventory.yml site_gpu_nodes.yml -K

## Run ansible scripts
Basic command is:
> ansible-playbook -i inventory.yml site.yml -K

where:
| 

| Command Option | Description |
|----------------|-------------|
| ansible-playbook | This is the Ansible command used to run playbooks. A playbook is a file containing a series of tasks that Ansible will execute on the specified hosts. |
| -i hosts | The -i option specifies the inventory file. In this case, hosts is the inventory file that lists the target hosts and their groupings. This file tells Ansible which machines to run the tasks on. |
| site.yml | This is the name of the playbook file. site.yml contains the tasks and roles that Ansible will execute on the specified hosts. |
| -K | This option prompts the user for the sudo password. It stands for “ask for privilege escalation password.” This is necessary when tasks in the playbook require elevated privileges (sudo) to execute. |


## Ссылки
https://infotechys.com/install-kubernetes-using-ansible-on-ubuntu-24-04/
https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
https://blog.kubesimplify.com/kubernetes-on-apple-macbooks-m-series
https://docs.dronahq.com/self-hosted-deployment/deploy-kubernetes-on-macos/
https://github.com/ids/cluster-builder-vbox
https://kubernetes.io/ru/docs/concepts/
https://github.com/Chris-Greaves/metallb-ansible
https://github.com/hatamiarash7/Ansible-Install-MetalLb
https://baltig.infn.it/mgattari/ansible-role-gpu-support
https://github.com/NVIDIA/k8s-device-plugin
https://github.com/rohinijoshi06/jupyterhub-on-k8s/tree/master
