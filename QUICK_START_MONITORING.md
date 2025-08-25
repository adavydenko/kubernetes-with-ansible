# 🚀 Быстрый старт с Monitoring

Краткая инструкция по развертыванию системы мониторинга Prometheus + Grafana в Kubernetes кластере.

## 📋 Предварительные требования

- ✅ Kubernetes кластер развернут
- ✅ MetalLB настроен
- ✅ Local Storage настроен
- ✅ Ansible доступен
- ✅ SSH доступ к узлам кластера

## ⚡ Быстрая установка

### 1. Установка Monitoring

```bash
# Установка системы мониторинга
ansible-playbook -i inventory.yml site.yml --tags monitoring
```

### 2. Тестирование

```bash
# Автоматический тест
./scripts/test-monitoring.sh
```

### 3. Доступ к интерфейсам

```bash
# Доступ к Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Открыть http://localhost:9090

# Доступ к Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Открыть http://localhost:3000
# Логин: admin / admin123
```

## 🔍 Проверка установки

```bash
# Проверка подов мониторинга
kubectl get pods -n monitoring

# Проверка сервисов
kubectl get svc -n monitoring

# Проверка PVC
kubectl get pvc -n monitoring
```

## 📊 Что мониторится

### Узлы кластера:
- CPU использование
- Память (RAM)
- Дисковое пространство
- Сетевая активность
- Температура (если доступно)

### Kubernetes:
- Состояние подов
- Состояние сервисов
- Использование ресурсов
- События кластера

### Приложения:
- Доступность сервисов
- Время ответа
- Количество запросов
- Ошибки

## 🎯 Настройка Grafana

### 1. Добавление Prometheus как источника данных

1. Откройте Grafana (http://localhost:3000)
2. Логин: `admin` / `admin123`
3. Перейдите в Configuration → Data Sources
4. Нажмите "Add data source"
5. Выберите "Prometheus"
6. URL: `http://prometheus.monitoring.svc.cluster.local:9090`
7. Нажмите "Save & Test"

### 2. Импорт дашбордов

#### Kubernetes Cluster Monitoring:
1. Перейдите в Dashboards → Import
2. Введите ID: `315`
3. Выберите Prometheus как источник данных
4. Нажмите "Import"

#### Node Exporter Dashboard:
1. Перейдите в Dashboards → Import
2. Введите ID: `1860`
3. Выберите Prometheus как источник данных
4. Нажмите "Import"

#### Prometheus Stats:
1. Перейдите в Dashboards → Import
2. Введите ID: `3662`
3. Выберите Prometheus как источник данных
4. Нажмите "Import"

## 🚨 Настройка алертов

### 1. Создание правил алертов

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-alerts
  namespace: monitoring
data:
  alert_rules.yml: |
    groups:
    - name: kubernetes
      rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for 5 minutes"
      
      - alert: HighMemoryUsage
        expr: (node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100 > 85
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High memory usage on {{ $labels.instance }}"
          description: "Memory usage is above 85% for 5 minutes"
      
      - alert: DiskSpaceLow
        expr: (node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"} < 10
        for: 5m
        labels:
          severity: critical
        annotations:
          summary: "Low disk space on {{ $labels.instance }}"
          description: "Disk space is below 10%"
```

### 2. Применение правил

```bash
kubectl apply -f prometheus-alerts.yaml
```

## 🛠 Устранение неполадок

### Prometheus не запускается
```bash
kubectl logs -n monitoring deployment/prometheus
kubectl describe pod -n monitoring -l app=prometheus
```

### Grafana не доступна
```bash
kubectl logs -n monitoring deployment/grafana
kubectl get svc grafana -n monitoring
```

### Node Exporter не собирает метрики
```bash
kubectl get pods -n monitoring -l app=node-exporter
kubectl logs -n monitoring daemonset/node-exporter
```

### Проверка метрик
```bash
# Проверка метрик Node Exporter
kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://node-exporter.monitoring.svc.cluster.local:9100/metrics | head -20

# Проверка целей Prometheus
kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://localhost:9090/api/v1/targets
```

## 📈 Полезные запросы Prometheus

### CPU использование:
```
100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)
```

### Память использование:
```
(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100
```

### Дисковое пространство:
```
(node_filesystem_avail_bytes{mountpoint="/"} * 100) / node_filesystem_size_bytes{mountpoint="/"}
```

### Количество подов:
```
count(kube_pod_info)
```

### Состояние узлов:
```
kube_node_status_condition
```

## 📚 Дополнительная документация

- [Подробное руководство](monitoring/README.md)
- [Тестовый скрипт](scripts/test-monitoring.sh)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

## 🎯 Что дальше?

1. ✅ **Monitoring установлен**
2. 🔄 **Настройте дашборды в Grafana**
3. 🔄 **Настройте алерты**
4. 🔄 **Настройте внешний доступ**
5. 🔄 **Настройте бэкапы метрик**
