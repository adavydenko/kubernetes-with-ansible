# Quick Start Guide

## 🚀 Быстрый старт за 5 минут

### 1. Подготовка окружения

```bash
# Установка Ansible
sudo apt update && sudo apt install ansible -y

# Клонирование репозитория
git clone <repository-url>
cd kubernetes-with-ansible

# Настройка SSH ключей
ssh-keygen -t rsa -b 4096 -C "ansible@control"
ssh-copy-id user@10.0.2.5  # master
ssh-copy-id user@10.0.2.6  # worker-01
ssh-copy-id user@10.0.2.7  # worker-02
```

### 2. Настройка inventory

Отредактируйте `inventory.yml`:

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
```

### 3. Развертывание

```bash
# Полное развертывание кластера с MetalLB
ansible-playbook -i inventory.yml site.yml
```

### 4. Проверка результатов

```bash
# Подключение к master узлу
ssh user@10.0.2.5

# Проверка кластера
kubectl get nodes
kubectl get pods --all-namespaces

# Проверка MetalLB
kubectl get pods -n metallb-system

# Проверка демо-приложения
kubectl get service -n demo
curl http://10.0.2.240
```

## 📋 Что получится

✅ **Kubernetes кластер** с 1 master и 2 worker узлами  
✅ **Flannel CNI** для сетевого взаимодействия  
✅ **MetalLB** для LoadBalancer сервисов  
✅ **Демо-приложение** nginx с внешним IP  
✅ **Готовое к использованию** решение  

## 🔧 Полезные команды

```bash
# Проверка статуса кластера
kubectl get nodes
kubectl get pods --all-namespaces

# Создание LoadBalancer сервиса
kubectl create deployment my-app --image=nginx
kubectl expose deployment my-app --port=80 --type=LoadBalancer

# Автоматическое тестирование
./scripts/test-metallb.sh

# Просмотр логов
kubectl logs -n metallb-system -l app=metallb
```

## 🆘 Устранение неполадок

### Проблема: Узлы не присоединяются
```bash
# Проверка join команды
kubeadm token create --print-join-command
```

### Проблема: MetalLB не назначает IP
```bash
# Проверка логов
kubectl logs -n metallb-system -l app=metallb
```

### Проблема: Нельзя получить доступ к приложению
```bash
# Проверка сервиса
kubectl get service -n demo
ping <EXTERNAL_IP>
```

## 📚 Дополнительная документация

- [Полное руководство по развертыванию](DEPLOYMENT_GUIDE.md)
- [Настройка MetalLB](METALLB_SETUP.md)
- [Примеры использования](examples/metallb-examples.yml)

## 🎯 Следующие шаги

1. **Настройка мониторинга** - установка Prometheus и Grafana
2. **Настройка безопасности** - RBAC, Network Policies
3. **Развертывание приложений** - использование Helm charts
4. **Масштабирование** - добавление новых worker узлов
