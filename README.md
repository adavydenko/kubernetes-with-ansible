# Kubernetes кластер с Ansible, MetalLB, Local Storage и Monitoring

Репозиторий содержит Ansible роли для автоматизированного развертывания Kubernetes кластера с дополнительными компонентами.

## 📚 Учебные материалы

### 🎓 Основное пособие
- **[LEARNING_GUIDE.md](LEARNING_GUIDE.md)** - Полное учебное пособие с теорией, практикой и упражнениями
- **[PROGRESS_CHECKLISTS.md](PROGRESS_CHECKLISTS.md)** - Чек-листы для самооценки прогресса обучения

### 📝 Практические материалы
- **[EXERCISES.md](EXERCISES.md)** - Базовые упражнения по всем темам
- **[EXERCISES_6.1.md](EXERCISES_6.1.md)** - Расширенные упражнения по RBAC
- **[EXERCISES_6.2.md](EXERCISES_6.2.md)** - Расширенные упражнения по операторам
- **[EXERCISES_6.3.md](EXERCISES_6.3.md)** - Расширенные упражнения по GitOps

### 🚀 Быстрый старт
- **[QUICK_START.md](QUICK_START.md)** - Быстрое развертывание кластера
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Подробное руководство по развертыванию

## 📋 Содержание

- [K8s Cluster Setup](#k8s-cluster-setup)
  - [Настройка окружений](#настройка-окружений)
  - [VMs](#vms)
  - [Prerequisites (nodes)](#prerequisites-nodes)
  - [Prerequisites (Ansible host)](#prerequisites-ansible-host)
- [Ansible roles](#ansible-roles)
  - [kubernetes\_master](#kubernetes_master)
  - [kubernetes\_worker](#kubernetes_worker)
  - [kubernetes\_network](#kubernetes_network)
- [Ссылки](#ссылки)


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


### Пререквезиты (nodes)
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

### Пререквезиты (Ansible host)
Установка кластера будет производиться с помощью инструмента Ansible. Ansible – это проект с открытым исходным кодом, предназначенный для автоматизации административных задач, в нашем случае мы будем автоматизировать разветывание k8s кластеры с помощью него.
Для этого необходимо выделить отдельную ноду вне кластера, на которой будет запущен Ansible и с которой будет производиться установка.

> Конечно, совсем не обязательно выделять отдельный хост для запуска Ansible-скриптов – это можно сделать и с локальной машины, но выделяя отдельную машину/хост под задачи автоматизации вы таким образом упрощаете работу.

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
Роль для настройки master-ноды Kubernetes кластера. Включает:
- Установку и настройку containerd
- Установку компонентов Kubernetes (kubeadm, kubelet, kubectl)
- Инициализацию control plane
- Настройку сетевых параметров

### kubernetes_worker
Роль для настройки worker-нод Kubernetes кластера. Включает:
- Установку и настройку containerd
- Установку компонентов Kubernetes
- Присоединение к кластеру
- Настройку сетевых параметров

### kubernetes_network
Роль для настройки сетевого плагина Flannel. Включает:
- Установку Flannel CNI
- Настройку pod network CIDR
- Конфигурацию сетевого взаимодействия

### metallb
Роль для установки и настройки MetalLB load balancer. Включает:
- Установку MetalLB в кластере
- Настройку IP address pools
- Конфигурацию Layer 2 advertisement
- Верификацию установки

### storage
Роль для настройки Local Storage Provisioner - простого и эффективного решения для постоянного хранения данных без использования внешнего NFS. Включает:
- Local Storage Provisioner с автоматическим обнаружением томов
- Создание StorageClass для управления томами
- Настройку путей хранения на worker узлах
- Высокую производительность локального хранения

### monitoring
Роль для настройки системы мониторинга Prometheus + Grafana. Включает:
- Prometheus для сбора и хранения метрик
- Grafana для визуализации и дашбордов
- Node Exporter для метрик узлов кластера
- Настройку алертов и уведомлений

### demo_app
Роль для развертывания демо-приложения для тестирования MetalLB. Включает:
- Развертывание nginx приложения
- Создание LoadBalancer сервиса
- Верификацию работы внешнего IP

## Быстрый старт

### Предварительные требования

1. **Системные требования:**
   - Control Node: Ubuntu Desktop 24.10 (2GB RAM, 20GB диска)
   - Master Node: Ubuntu Server 24.04 LTS (4GB RAM, 30GB диска)
   - Worker Nodes: Ubuntu Server 24.04 LTS (4GB RAM, 30GB диска каждый)
   - Все узлы в одной L2 сети

2. **Сетевая схема:**
   ```
   Control Node:    10.0.2.15
   Master Node:     10.0.2.5
   Worker Node 1:   10.0.2.6
   Worker Node 2:   10.0.2.7
   ...
   MetalLB Pool:    10.0.2.240 - 10.0.2.250
   ```

3. **Программное обеспечение:**
   - Ansible 2.14+
   - SSH доступ между всеми узлами

### Настройка Control Node

```bash
# Установка Ansible
sudo apt update
sudo apt install ansible -y

# Генерация SSH ключей
ssh-keygen -t rsa -b 4096 -C "ansible@control"

# Копирование ключей на все узлы
ssh-copy-id user@10.0.2.5  # master
ssh-copy-id user@10.0.2.6  # worker-01
ssh-copy-id user@10.0.2.7  # worker-02
# ... повторить для всех worker узлов

# Клонирование репозитория
git clone <repository-url>
cd kubernetes-with-ansible
```

### Настройка Inventory

Отредактируйте `inventory.yml` под вашу среду:

```yaml
all:
  children:
    master_nodes:
      hosts:
        kube-master:
          ansible_host: 10.0.2.5
          ansible_user: your_username
    worker_nodes:
      hosts:
        kube-worker-01:
          ansible_host: 10.0.2.6
          ansible_user: your_username
        kube-worker-02:
          ansible_host: 10.0.2.7
          ansible_user: your_username
        # Добавьте больше worker узлов по необходимости
```

### Развертывание кластера

#### Полное развертывание
```bash
# Развертывание полного кластера с MetalLB, Local Storage и Monitoring
ansible-playbook -i inventory.yml site.yml
```

#### Поэтапное развертывание
```bash
# Только master узел
ansible-playbook -i inventory.yml site.yml --limit master_nodes

# Сетевая настройка (Flannel)
ansible-playbook -i inventory.yml site.yml --tags kubernetes_network

# Worker узлы
ansible-playbook -i inventory.yml site.yml --limit worker_nodes

# MetalLB
ansible-playbook -i inventory.yml site.yml --tags metallb

# Local Storage
ansible-playbook -i inventory.yml site.yml --tags storage

# Monitoring
ansible-playbook -i inventory.yml site.yml --tags monitoring

# Демо-приложение
ansible-playbook -i inventory.yml site.yml --tags demo_app
```

## Результат развертывания

После успешного выполнения скриптов у вас будет:

### 1. Kubernetes кластер
- ✅ Master узел с control plane
- ✅ Worker узлы для выполнения нагрузки
- ✅ Flannel CNI для сетевого взаимодействия
- ✅ Все компоненты Kubernetes работают

### 2. MetalLB Load Balancer
- ✅ MetalLB установлен в namespace `metallb-system`
- ✅ IP пул настроен: `10.0.2.240-10.0.2.250`
- ✅ Layer 2 advertisement настроен
- ✅ Готов к назначению внешних IP

### 3. Local Storage
- ✅ Local Storage Provisioner установлен
- ✅ StorageClass создан для автоматического управления томами
- ✅ PersistentVolumes доступны для приложений
- ✅ Высокая производительность локального хранения

### 4. Monitoring
- ✅ Prometheus установлен для сбора метрик
- ✅ Grafana установлен для визуализации
- ✅ Node Exporter собирает метрики узлов
- ✅ Система готова к настройке алертов

### 5. Демо-приложение
- ✅ Nginx развернут с 3 репликами
- ✅ LoadBalancer сервис создан
- ✅ Внешний IP назначен автоматически
- ✅ Приложение доступно извне кластера

## Проверка результатов

### 1. Проверка кластера

```bash
# Подключение к master узлу
ssh user@10.0.2.5

# Проверка узлов кластера
kubectl get nodes

# Ожидаемый результат:
# NAME           STATUS   ROLES           AGE   VERSION
# kube-master    Ready    control-plane   5m    v1.31.0
# kube-worker-01 Ready    <none>          4m    v1.31.0
# kube-worker-02 Ready    <none>          4m    v1.31.0

# Проверка всех подов
kubectl get pods --all-namespaces

# Ожидаемый результат - все поды в статусе Running
```

### 2. Проверка MetalLB

```bash
# Проверка namespace MetalLB
kubectl get namespace metallb-system

# Проверка подов MetalLB
kubectl get pods -n metallb-system

# Ожидаемый результат:
# NAME                          READY   STATUS    RESTARTS   AGE
# controller-xxx                1/1     Running   0          2m
# speaker-xxx                   1/1     Running   0          2m
# speaker-xxx                   1/1     Running   0          2m

# Проверка IP пулов
kubectl get ipaddresspools -n metallb-system

# Проверка L2 advertisements
kubectl get l2advertisements -n metallb-system
```

### 3. Проверка демо-приложения

```bash
# Проверка демо-приложения
kubectl get deployment -n demo

# Ожидаемый результат:
# NAME        READY   UP-TO-DATE   AVAILABLE   AGE
# nginx-demo  3/3     3            3           2m

# Проверка сервиса
kubectl get service -n demo

# Ожидаемый результат:
# NAME                TYPE           CLUSTER-IP      EXTERNAL-IP    PORT(S)        AGE
# nginx-demo-service  LoadBalancer   10.96.xxx.xxx   10.0.2.240     80:xxxxx/TCP   2m

# Тестирование доступа
curl http://10.0.2.240

# Ожидаемый результат - HTML страница nginx
```

### 4. Автоматическое тестирование

```bash
# Запуск автоматического теста MetalLB
./scripts/test-metallb.sh

# Запуск автоматического теста Local Storage
./scripts/test-local-storage.sh

# Запуск автоматического теста Monitoring
./scripts/test-monitoring.sh

# Ожидаемый результат:
# ✓ kubectl is available
# ✓ MetalLB namespace exists
# ✓ MetalLB pods are running
# ✓ IP address pools configured
# ✓ L2 advertisements configured
# ✓ Test application deployed
# ✓ External IP assigned: 10.0.2.240
# ✓ HTTP connectivity test passed
```

## Настройка kubectl на Control Node

```bash
# Копирование kubeconfig с master узла
scp user@10.0.2.5:/etc/kubernetes/admin.conf ~/.kube/config

# Установка прав доступа
chmod 600 ~/.kube/config

# Проверка подключения
kubectl get nodes
```

## Создание собственных приложений

После развертывания вы можете создавать LoadBalancer сервисы:

```bash
# Создание deployment
kubectl create deployment my-app --image=nginx

# Создание LoadBalancer сервиса
kubectl expose deployment my-app --port=80 --type=LoadBalancer

# Проверка внешнего IP
kubectl get service my-app
```

## Устранение неполадок

### Частые проблемы

1. **Узлы не присоединяются к кластеру:**
   ```bash
   # Проверка join команды на master
   kubeadm token create --print-join-command
   
   # Проверка логов kubelet на worker
   sudo journalctl -u kubelet -f
   ```

2. **MetalLB не назначает IP:**
   ```bash
   # Проверка логов MetalLB
   kubectl logs -n metallb-system -l app=metallb -c controller
   kubectl logs -n metallb-system -l app=metallb -c speaker
   ```

3. **Проблемы с сетью:**
   ```bash
   # Проверка подов Flannel
   kubectl get pods -n kube-flannel
   
   # Тест сетевого соединения
   ping 10.0.2.5  # с worker на master
   ```

### Полезные команды для диагностики

```bash
# События кластера
kubectl get events --sort-by='.lastTimestamp'

# Детали узла
kubectl describe node <node-name>

# Детали пода
kubectl describe pod <pod-name> -n <namespace>

# Детали сервиса
kubectl describe service <service-name> -n <namespace>
```


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
### MetalLB Resources
https://metallb.universe.tf/
https://metallb.universe.tf/installation/
https://metallb.universe.tf/configuration/
https://github.com/Chris-Greaves/metallb-ansible
https://github.com/hatamiarash7/Ansible-Install-MetalLb
https://baltig.infn.it/mgattari/ansible-role-gpu-support
https://github.com/NVIDIA/k8s-device-plugin
https://github.com/rohinijoshi06/jupyterhub-on-k8s/tree/master
