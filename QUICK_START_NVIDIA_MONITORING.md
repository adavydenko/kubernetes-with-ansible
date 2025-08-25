# 🚀 Быстрый старт с NVIDIA GPU Мониторингом

Краткая инструкция по настройке мониторинга GPU в Kubernetes кластере.

## 📋 Предварительные требования

- ✅ Kubernetes кластер развернут
- ✅ Система мониторинга установлена
- ✅ NVIDIA драйверы установлены на узлах с GPU
- ✅ NVIDIA Container Runtime настроен

## ⚡ Быстрая настройка

### 1. Включение NVIDIA мониторинга

```bash
# Отредактируйте файл monitoring/defaults/main.yml
nvidia_exporter_enabled: true
```

### 2. Переустановка мониторинга

```bash
# Переустановка с NVIDIA Exporter
ansible-playbook -i inventory.yml site.yml --tags monitoring
```

### 3. Проверка установки

```bash
# Проверка подов NVIDIA Exporter
kubectl get pods -n monitoring -l app=nvidia-exporter

# Проверка сервиса
kubectl get svc nvidia-exporter -n monitoring
```

## 🔍 Доступ к GPU метрикам

### Через port-forward:
```bash
# Доступ к метрикам GPU
kubectl port-forward -n monitoring svc/nvidia-exporter 9400:9400
curl http://localhost:9400/metrics
```

### Через Prometheus:
```bash
# Доступ к Prometheus
kubectl port-forward -n monitoring svc/prometheus 9090:9090
# Открыть http://localhost:9090
# Запрос: DCGM_FI_DEV_GPU_UTIL
```

## 📊 Основные GPU метрики

### Использование ресурсов:
- `DCGM_FI_DEV_GPU_UTIL` - использование GPU (%)
- `DCGM_FI_DEV_FB_USED` - использованная память (bytes)
- `DCGM_FI_DEV_FB_TOTAL` - общая память (bytes)

### Температура и энергия:
- `DCGM_FI_DEV_GPU_TEMP` - температура GPU (°C)
- `DCGM_FI_DEV_POWER_USAGE` - потребление энергии (W)
- `DCGM_FI_DEV_FAN_SPEED` - скорость вентилятора (%)

### Память:
- `DCGM_FI_DEV_FB_FREE` - свободная память (bytes)
- `DCGM_FI_DEV_FB_RESERVED` - зарезервированная память (bytes)

## 🎯 Настройка Grafana

### 1. Добавление дашборда GPU

1. Откройте Grafana (http://localhost:3000)
2. Перейдите в Dashboards → Import
3. Введите ID: `14574` (NVIDIA DCGM Exporter Dashboard)
4. Выберите Prometheus как источник данных
5. Нажмите "Import"

### 2. Создание собственного дашборда

```json
{
  "dashboard": {
    "title": "GPU Monitoring",
    "panels": [
      {
        "title": "GPU Utilization",
        "type": "graph",
        "targets": [
          {
            "expr": "DCGM_FI_DEV_GPU_UTIL",
            "legendFormat": "GPU {{gpu}}"
          }
        ]
      },
      {
        "title": "GPU Memory Usage",
        "type": "graph",
        "targets": [
          {
            "expr": "(DCGM_FI_DEV_FB_USED / DCGM_FI_DEV_FB_TOTAL) * 100",
            "legendFormat": "GPU {{gpu}}"
          }
        ]
      }
    ]
  }
}
```

## 🚨 Настройка алертов

### Применение готовых алертов:

```bash
# Применение алертов GPU
kubectl apply -f examples/monitoring-alerts.yml
```

### Основные алерты:

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

- alert: HighGPUMemoryUsage
  expr: (DCGM_FI_DEV_FB_USED / DCGM_FI_DEV_FB_TOTAL) * 100 > 85
  for: 5m
  labels:
    severity: warning
  annotations:
    summary: "High GPU memory usage on {{ $labels.gpu }}"
```

## 🛠 Устранение неполадок

### NVIDIA Exporter не запускается:
```bash
# Проверка логов
kubectl logs -n monitoring daemonset/nvidia-exporter

# Проверка событий
kubectl describe pod -n monitoring -l app=nvidia-exporter

# Проверка NVIDIA драйверов на узле
kubectl exec -it <nvidia-pod> -- nvidia-smi
```

### Нет метрик GPU:
```bash
# Проверка доступности метрик
kubectl port-forward -n monitoring svc/nvidia-exporter 9400:9400
curl http://localhost:9400/metrics | grep DCGM

# Проверка целей в Prometheus
kubectl exec -n monitoring deployment/prometheus -- wget -qO- http://localhost:9090/api/v1/targets
```

### Проблемы с правами:
```bash
# Проверка security context
kubectl get daemonset nvidia-exporter -n monitoring -o yaml | grep -A 10 securityContext

# Проверка tolerations
kubectl get daemonset nvidia-exporter -n monitoring -o yaml | grep -A 5 tolerations
```

## 📈 Полезные запросы Prometheus

### Использование GPU:
```
DCGM_FI_DEV_GPU_UTIL
```

### Память GPU:
```
(DCGM_FI_DEV_FB_USED / DCGM_FI_DEV_FB_TOTAL) * 100
```

### Температура GPU:
```
DCGM_FI_DEV_GPU_TEMP
```

### Потребление энергии:
```
DCGM_FI_DEV_POWER_USAGE
```

### Количество GPU:
```
count(DCGM_FI_DEV_GPU_UTIL)
```

## 🎯 Рекомендации

### Для кластера с GPU:

1. **Настройте алерты** - для критических событий GPU
2. **Мониторьте температуру** - избегайте перегрева
3. **Следите за памятью** - оптимизируйте использование
4. **Настройте retention** - GPU метрики важны для анализа
5. **Регулярно обновляйте** - драйверы и экспортер

### Оптимизация производительности:

1. **Настройте интервал сбора** - баланс между точностью и нагрузкой
2. **Используйте фильтры** - исключите ненужные метрики
3. **Настройте retention** - GPU метрики занимают много места
4. **Мониторьте ресурсы** - сам экспортер потребляет ресурсы

## 📚 Дополнительные ресурсы

- [NVIDIA DCGM Documentation](https://docs.nvidia.com/datacenter/dcgm/)
- [DCGM Exporter GitHub](https://github.com/NVIDIA/dcgm-exporter)
- [GPU Monitoring Best Practices](https://docs.nvidia.com/datacenter/cloud-native/kubernetes/monitoring.html)
- [Примеры конфигурации](examples/nvidia-monitoring-example.yml)
