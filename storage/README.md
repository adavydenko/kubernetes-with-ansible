# Storage Role - Local Storage Provisioner

Эта роль настраивает Local Storage Provisioner для Kubernetes кластера - простое и эффективное решение для постоянного хранения данных без использования внешнего NFS.

## Описание

Local Storage Provisioner использует локальные диски узлов кластера для создания PersistentVolumes. Это идеальное решение для кластеров без внешних систем хранения.

### Преимущества:
- ✅ Простая настройка
- ✅ Высокая производительность
- ✅ Не требует дополнительной инфраструктуры
- ✅ Минимальное потребление ресурсов

### Ограничения:
- ❌ Нет репликации данных
- ❌ Данные привязаны к конкретному узлу
- ❌ Потеря данных при выходе узла из строя

## Конфигурация

### Настройка путей хранения

```yaml
# В defaults/main.yml
local_storage_paths:
  - path: "/mnt/disk1"
    storage_class: "local-storage"
    volume_mode: "Filesystem"
  - path: "/mnt/disk2" 
    storage_class: "local-storage"
    volume_mode: "Filesystem"
```

### Storage Class

```yaml
storage_classes:
  - name: "local-storage"
    provisioner: "kubernetes.io/no-provisioner"
    volume_binding_mode: "WaitForFirstConsumer"
    reclaim_policy: "Retain"
    is_default: false
```

## Использование

### Создание PersistentVolumeClaim

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: my-app-pvc
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 10Gi
```

### Использование в Pod

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: my-app
spec:
  containers:
  - name: app
    image: nginx
    volumeMounts:
    - name: app-storage
      mountPath: /data
  volumes:
  - name: app-storage
    persistentVolumeClaim:
      claimName: my-app-pvc
```

## Мониторинг

### Проверка состояния

```bash
# Проверка Storage Class
kubectl get storageclass local-storage

# Проверка PersistentVolumes
kubectl get pv

# Проверка PersistentVolumeClaims
kubectl get pvc --all-namespaces

# Проверка подов Local Storage Provisioner
kubectl get pods -n local-storage-system
```

### Проверка логов

```bash
# Логи Local Storage Provisioner
kubectl logs -n local-storage-system -l app=local-volume-discovery

# События кластера
kubectl get events --sort-by='.lastTimestamp'
```

## Устранение неполадок

### PVC не привязывается

```bash
# Проверка статуса PVC
kubectl describe pvc <pvc-name>

# Проверка доступных PersistentVolumes
kubectl get pv

# Проверка подов Local Storage Provisioner
kubectl get pods -n local-storage-system
```

### Pod не может монтировать том

```bash
# Проверка событий пода
kubectl describe pod <pod-name>

# Проверка логов пода
kubectl logs <pod-name>

# Проверка прав доступа к директории
kubectl exec <pod-name> -- ls -la /data
```

## Требования к системе

- Минимум 10GB свободного места на каждом worker узле
- Права на создание директорий
- Kubernetes кластер с настроенным CNI

