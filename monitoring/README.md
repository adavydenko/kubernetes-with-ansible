# Monitoring Role - Prometheus + Grafana

Эта роль настраивает полную систему мониторинга для Kubernetes кластера с использованием Prometheus, Grafana и Node Exporter.

## Описание

Система мониторинга включает:

### ✅ Компоненты:
- **Prometheus** - сбор и хранение метрик
- **Grafana** - визуализация и дашборды
- **Node Exporter** - метрики узлов кластера
- **NVIDIA Node Exporter** - метрики GPU (опционально)
- **Alertmanager** - управление алертами (готов к настройке)

### 📊 Что мониторится:
- Состояние узлов кластера (CPU, память, диск)
- Состояние подов и сервисов
- Метрики Kubernetes API
- Пользовательские метрики приложений
- Метрики GPU (если включен NVIDIA Exporter)

## Конфигурация

### Основные настройки

```yaml
# В defaults/main.yml
prometheus_enabled: true
grafana_enabled: true
node_exporter_enabled: true
nvidia_exporter_enabled: false  # Включить для GPU мониторинга
alertmanager_enabled: true

# Хранилище
monitoring_storage_class: "local-storage"
prometheus_storage_size: "10Gi"
grafana_storage_size: "5Gi"
```

### Ресурсы

```yaml
prometheus_resources:
  requests:
    memory: "512Mi"
    cpu: "250m"
  limits:
    memory: "1Gi"
    cpu: "500m"

grafana_resources:
  requests:
    memory: "128Mi"
    cpu: "100m"
  limits:
    memory: "256Mi"
    cpu: "200m"
```

## Использование

### Установка

```bash
# Установка системы мониторинга
ansible-playbook -i inventory.yml site.yml --tags monitoring
```

### Доступ к интерфейсам

```bash
# Доступ к Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Открыть http://localhost:9090

# Доступ к Grafana
kubectl port-forward -n monitoring svc/grafana 3000:3000
# Открыть http://localhost:3000
# Логин: admin / admin123
```

### Проверка состояния

```bash
# Проверка подов мониторинга
kubectl get pods -n monitoring

# Проверка сервисов
kubectl get svc -n monitoring

# Проверка PVC
kubectl get pvc -n monitoring
```

## Мониторинг

### Prometheus

**URL:** http://localhost:9090 (через port-forward)

**Основные метрики:**
- `up` - состояние сервисов
- `node_cpu_seconds_total` - использование CPU
- `node_memory_MemAvailable_bytes` - доступная память
- `kube_pod_status_phase` - состояние подов

### Grafana

**URL:** http://localhost:3000 (через port-forward)
**Логин:** admin / admin123

**Готовые дашборды:**
- Kubernetes Cluster Monitoring
- Node Exporter Dashboard
- Prometheus Stats

## Настройка алертов

### Создание правил алертов

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
```

### Настройка уведомлений

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: alertmanager-config
  namespace: monitoring
data:
  alertmanager.yml: |
    global:
      smtp_smarthost: 'localhost:587'
      smtp_from: 'alertmanager@example.com'
    
    route:
      group_by: ['alertname']
      group_wait: 10s
      group_interval: 10s
      repeat_interval: 1h
      receiver: 'web.hook'
    
    receivers:
    - name: 'web.hook'
      webhook_configs:
      - url: 'http://127.0.0.1:5001/'
```

## Устранение неполадок

### Prometheus не запускается

```bash
# Проверка логов
kubectl logs -n monitoring deployment/prometheus

# Проверка конфигурации
kubectl get configmap prometheus-config -n monitoring -o yaml

# Проверка PVC
kubectl describe pvc prometheus-data -n monitoring
```

### Grafana не доступна

```bash
# Проверка логов
kubectl logs -n monitoring deployment/grafana

# Проверка сервиса
kubectl get svc grafana -n monitoring

# Проверка PVC
kubectl describe pvc grafana-data -n monitoring
```

### Node Exporter не собирает метрики

```bash
# Проверка подов на всех узлах
kubectl get pods -n monitoring -l app=node-exporter

# Проверка логов
kubectl logs -n monitoring daemonset/node-exporter

# Проверка сервиса
kubectl get svc node-exporter -n monitoring
```

## Требования к системе

- Kubernetes кластер с настроенным CNI
- Local Storage Provisioner (или другой StorageClass)
- Минимум 1GB свободной памяти на узлах
- Минимум 20GB свободного места для хранения метрик

## Рекомендации

### Для кластера из 10 машин:

1. **Настройте retention** - 15 дней для Prometheus
2. **Мониторьте дисковое пространство** - метрики растут быстро
3. **Настройте алерты** - для критических событий
4. **Регулярно обновляйте** - версии компонентов

### Оптимизация производительности:

1. **Увеличьте ресурсы** Prometheus при необходимости
2. **Настройте scrape_interval** - баланс между точностью и нагрузкой
3. **Используйте фильтры** - исключите ненужные метрики
4. **Настройте retention** - удаляйте старые данные

## Расширение мониторинга

### Добавление пользовательских метрик

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-app
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/metrics"
```

### Настройка дополнительных экспортеров

- **cAdvisor** - для контейнерных метрик
- **kube-state-metrics** - для метрик Kubernetes объектов
- **blackbox-exporter** - для мониторинга доступности
- **NVIDIA Node Exporter** - для метрик GPU

## NVIDIA GPU Мониторинг

### Включение NVIDIA Exporter

1. **Установите NVIDIA драйверы** на узлах с GPU
2. **Настройте NVIDIA Container Runtime**
3. **Включите мониторинг GPU**:

```yaml
# В defaults/main.yml
nvidia_exporter_enabled: true
```

4. **Переустановите мониторинг**:
```bash
ansible-playbook -i inventory.yml site.yml --tags monitoring
```

### GPU метрики

**Основные метрики:**
- `DCGM_FI_DEV_GPU_UTIL` - использование GPU (%)
- `DCGM_FI_DEV_FB_USED` - использованная память GPU (bytes)
- `DCGM_FI_DEV_FB_TOTAL` - общая память GPU (bytes)
- `DCGM_FI_DEV_GPU_TEMP` - температура GPU (°C)
- `DCGM_FI_DEV_POWER_USAGE` - потребление энергии (W)
- `DCGM_FI_DEV_FAN_SPEED` - скорость вентилятора (%)

### Проверка GPU мониторинга

```bash
# Проверка подов NVIDIA Exporter
kubectl get pods -n monitoring -l app=nvidia-exporter

# Доступ к метрикам GPU
kubectl port-forward -n monitoring svc/nvidia-exporter 9400:9400
curl http://localhost:9400/metrics

# Проверка в Prometheus
# Запрос: DCGM_FI_DEV_GPU_UTIL
```

### Примеры алертов для GPU

```yaml
- alert: HighGPUUtilization
  expr: DCGM_FI_DEV_GPU_UTIL > 90
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "High GPU utilization on {{ $labels.gpu }}"

- alert: GPUOverheating
  expr: DCGM_FI_DEV_GPU_TEMP > 80
  for: 2m
  labels:
    severity: critical
  annotations:
    summary: "GPU overheating on {{ $labels.gpu }}"
```
