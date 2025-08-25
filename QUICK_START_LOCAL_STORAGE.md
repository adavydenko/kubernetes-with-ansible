# 🚀 Быстрый старт с Local Storage

Краткая инструкция по развертыванию Kubernetes кластера с Local Storage Provisioner.

## 📋 Предварительные требования

- ✅ Kubernetes кластер развернут
- ✅ MetalLB настроен
- ✅ Ansible доступен
- ✅ SSH доступ к узлам кластера

## ⚡ Быстрая установка

### 1. Установка Local Storage

```bash
# Установка Local Storage Provisioner
ansible-playbook -i inventory.yml site.yml --tags storage
```

### 2. Тестирование

```bash
# Автоматический тест
./scripts/test-local-storage.sh
```

### 3. Демо-приложение

```bash
# Развертывание демо
kubectl apply -f examples/local-storage-example.yml

# Доступ к приложению
kubectl port-forward svc/storage-demo 8080:80
# Открыть http://localhost:8080
```

## 🔍 Проверка установки

```bash
# Проверка Storage Class
kubectl get storageclass

# Проверка подов Local Storage
kubectl get pods -n local-storage-system

# Проверка PersistentVolumes
kubectl get pv
```

## 📝 Быстрое использование

### Создание PVC

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 1Gi
```

### Использование в Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-pod
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: data
      mountPath: /data
  volumes:
  - name: data
    persistentVolumeClaim:
      claimName: my-pvc
```

## 🛠 Устранение неполадок

### PVC не привязывается
```bash
kubectl describe pvc <pvc-name>
kubectl get pv
```

### Pod не запускается
```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
```

### Проверка Local Storage
```bash
kubectl get pods -n local-storage-system
kubectl logs -n local-storage-system -l app=local-volume-discovery
```

## 📚 Дополнительная документация

- [Подробное руководство](storage/README.md)
- [Примеры использования](examples/local-storage-example.yml)
- [Тестовый скрипт](scripts/test-local-storage.sh)

