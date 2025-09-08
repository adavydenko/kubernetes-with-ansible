# Практические упражнения для изучения Kubernetes

## Уровень 1: Базовые концепции

### Упражнение 1.1: Изучение объектов Kubernetes
**Цель:** Понять основные объекты и их взаимосвязи

**Практическая важность:** Это фундаментальное упражнение знакомит с базовыми концепциями Kubernetes - Namespace для изоляции ресурсов, Deployment для управления подами, и Service для сетевого доступа. Понимание этих объектов критично для любого взаимодействия с кластером.

**Задачи:**
1. Создайте namespace `exercise-1`
2. Разверните nginx с 3 репликами
3. Создайте сервис типа ClusterIP
4. Проверьте доступность сервиса изнутри кластера

**Команды для выполнения:**
```bash
# 1. Создание namespace
kubectl create namespace exercise-1

# 2. Развертывание nginx
kubectl create deployment nginx-exercise --image=nginx:alpine --replicas=3 -n exercise-1

# 3. Создание сервиса
kubectl expose deployment nginx-exercise --port=80 --target-port=80 -n exercise-1

# 4. Проверка
kubectl get all -n exercise-1
kubectl run test-pod --image=busybox --rm -it --restart=Never -n exercise-1 -- wget -qO- http://nginx-exercise
```

**Ожидаемый результат:**
- 3 пода nginx в статусе Running
- Сервис с ClusterIP
- Успешный HTTP-запрос из тестового пода

---

### Упражнение 1.2: Работа с конфигурациями
**Цель:** Научиться использовать ConfigMap и Secret

**Практическая важность:** Управление конфигурациями и секретами - ключевой навык для продакшен-сред. ConfigMap позволяет отделить конфигурацию от кода, а Secret обеспечивает безопасное хранение чувствительных данных. Это основа для 12-factor приложений и безопасного развертывания.

**Задачи:**
1. Создайте ConfigMap с настройками приложения
2. Создайте Secret с паролем
3. Подключите их к поду
4. Проверьте доступность переменных окружения

**Команды для выполнения:**
```bash
# 1. ConfigMap
kubectl create configmap app-config --from-literal=ENVIRONMENT=production --from-literal=LOG_LEVEL=info -n exercise-1

# 2. Secret
kubectl create secret generic db-secret --from-literal=password=mysecretpassword -n exercise-1

# 3. Под с конфигурациями
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: config-test
  namespace: exercise-1
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'echo "ENV: $ENVIRONMENT, LOG: $LOG_LEVEL, PASS: $DB_PASSWORD"; sleep 3600']
    env:
    - name: ENVIRONMENT
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: ENVIRONMENT
    - name: LOG_LEVEL
      valueFrom:
        configMapKeyRef:
          name: app-config
          key: LOG_LEVEL
    - name: DB_PASSWORD
      valueFrom:
        secretKeyRef:
          name: db-secret
          key: password
EOF

# 4. Проверка
kubectl logs config-test -n exercise-1
```

---

## Уровень 2: Сети и сервисы

### Упражнение 2.1: Типы сервисов
**Цель:** Понять различия между типами сервисов

**Практическая важность:** Понимание типов сервисов критично для правильного проектирования сетевой архитектуры приложений. ClusterIP для внутреннего взаимодействия, NodePort для разработки, LoadBalancer для продакшена - каждый тип решает конкретные задачи. Это основа для создания масштабируемых микросервисных приложений.

**Задачи:**
1. Создайте сервисы всех типов (ClusterIP, NodePort, LoadBalancer)
2. Проверьте доступность каждого типа
3. Сравните поведение

**Команды для выполнения:**
```bash
# Создание deployment
kubectl create deployment web-app --image=nginx:alpine -n exercise-1

# ClusterIP (по умолчанию)
kubectl expose deployment web-app --name=web-clusterip --port=80 -n exercise-1

# NodePort
kubectl expose deployment web-app --name=web-nodeport --port=80 --type=NodePort -n exercise-1

# LoadBalancer (требует MetalLB)
kubectl expose deployment web-app --name=web-loadbalancer --port=80 --type=LoadBalancer -n exercise-1

# Проверка
kubectl get svc -n exercise-1
```

**Анализ результатов:**
- ClusterIP: доступен только внутри кластера
- NodePort: доступен через порт узла
- LoadBalancer: получает внешний IP от MetalLB

---

### Упражнение 2.2: Сетевая политика
**Цель:** Научиться изолировать трафик между подами

**Практическая важность:** Сетевые политики - основа безопасности в Kubernetes. Они позволяют реализовать принцип "минимальных привилегий" на сетевом уровне, изолируя трафик между компонентами приложения. Это критично для соответствия требованиям безопасности и защиты от атак типа "lateral movement".

**Задачи:**
1. Создайте два namespace с подами
2. Примените NetworkPolicy для изоляции
3. Проверьте ограничения трафика

**Команды для выполнения:**
```bash
# Создание namespace
kubectl create namespace frontend
kubectl create namespace backend

# Развертывание приложений
kubectl create deployment frontend-app --image=nginx:alpine -n frontend
kubectl create deployment backend-app --image=nginx:alpine -n backend

# Создание сервисов
kubectl expose deployment frontend-app --port=80 -n frontend
kubectl expose deployment backend-app --port=80 -n backend

# Добавление меток для NetworkPolicy
kubectl label namespace frontend kubernetes.io/metadata.name=frontend
kubectl label namespace backend kubernetes.io/metadata.name=backend

# NetworkPolicy для backend (разрешить только от frontend)
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: backend-policy
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: backend-app
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: frontend
    ports:
    - protocol: TCP
      port: 80
EOF

# Тестирование
kubectl run test-frontend --image=busybox --rm -it --restart=Never -n frontend -- wget -qO- http://backend-app.backend.svc.cluster.local
kubectl run test-default --image=busybox --rm -it --restart=Never -n default -- wget -qO- http://backend-app.backend.svc.cluster.local
```

---

## Уровень 3: Хранилище

### Упражнение 3.1: PersistentVolume и PVC
**Цель:** Научиться работать с постоянным хранилищем

**Практическая важность:** Постоянное хранилище необходимо для stateful приложений (базы данных, файловые серверы). PVC обеспечивает абстракцию от конкретной реализации хранилища, что позволяет легко мигрировать между различными провайдерами. Это основа для создания надежных приложений с сохранением данных.

**Задачи:**
1. Создайте PVC с Local Storage
2. Подключите том к поду
3. Запишите данные и проверьте их сохранность

**Команды для выполнения:**
```bash
# Создание PVC
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
  namespace: exercise-1
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: local-storage
  resources:
    requests:
      storage: 1Gi
EOF

# Под с томом
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: storage-test
  namespace: exercise-1
spec:
  containers:
  - name: app
    image: busybox
    command: ['sh', '-c', 'echo "Hello from $(date)" >> /data/test.txt; cat /data/test.txt; sleep 3600']
    volumeMounts:
    - name: data-volume
      mountPath: /data
  volumes:
  - name: data-volume
    persistentVolumeClaim:
      claimName: data-pvc
EOF

# Проверка
kubectl logs storage-test -n exercise-1
```

---

### Упражнение 3.2: StatefulSet
**Цель:** Понять разницу между Deployment и StatefulSet

**Практическая важность:** StatefulSet решает проблемы stateful приложений, обеспечивая стабильные идентификаторы, упорядоченное развертывание и уникальные тома для каждого пода. Это критично для кластерных баз данных, систем очередей и других приложений, требующих сохранения состояния и идентичности.

**Задачи:**
1. Создайте StatefulSet с базами данных
2. Проверьте стабильность имен и томов
3. Протестируйте масштабирование

**Команды для выполнения:**
```bash
# StatefulSet с PostgreSQL
cat <<EOF | kubectl apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: postgres
  namespace: exercise-1
spec:
  serviceName: "postgres"
  replicas: 2
  selector:
    matchLabels:
      app: postgres
  template:
    metadata:
      labels:
        app: postgres
    spec:
      containers:
      - name: postgres
        image: postgres:13
        env:
        - name: POSTGRES_PASSWORD
          value: "password"
        - name: POSTGRES_DB
          value: "testdb"
        ports:
        - containerPort: 5432
        volumeMounts:
        - name: postgres-storage
          mountPath: /var/lib/postgresql/data
        resources:
          requests:
            memory: "256Mi"
            cpu: "250m"
          limits:
            memory: "512Mi"
            cpu: "500m"
  volumeClaimTemplates:
  - metadata:
      name: postgres-storage
    spec:
      accessModes: ["ReadWriteOnce"]
      storageClassName: local-storage
      resources:
        requests:
          storage: 1Gi
EOF

# Сервис для StatefulSet
kubectl expose statefulset postgres --port=5432 -n exercise-1

# Проверка
kubectl get pods -n exercise-1
kubectl get pvc -n exercise-1
```

---

## Уровень 4: Мониторинг и алерты

### Упражнение 4.1: Настройка алертов
**Цель:** Научиться создавать и тестировать алерты

**Практическая важность:** Алерты - основа проактивного мониторинга и быстрого реагирования на проблемы. Правильно настроенные алерты позволяют обнаруживать проблемы до того, как они повлияют на пользователей, и автоматизировать реакции на инциденты. Это критично для обеспечения высокой доступности сервисов.

**Задачи:**
1. Создайте правила алертов для Prometheus
2. Настройте Alertmanager
3. Протестируйте срабатывание алертов

**Команды для выполнения:**
```bash
# Правила алертов
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: ConfigMap
metadata:
  name: prometheus-alerts
  namespace: monitoring
data:
  alert_rules.yml: |
    groups:
    - name: exercise-alerts
      rules:
      - alert: HighCPUUsage
        expr: 100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100) > 80
        for: 1m
        labels:
          severity: warning
        annotations:
          summary: "High CPU usage on {{ $labels.instance }}"
          description: "CPU usage is above 80% for 1 minute"
      
      - alert: PodCrashLooping
        expr: rate(kube_pod_container_status_restarts_total[15m]) * 60 > 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Pod is crash looping"
          description: "Pod {{ $labels.pod }} is restarting frequently"
EOF

# Применение правил
kubectl apply -f prometheus-alerts.yaml
```

---

### Упражнение 4.2: Создание дашборда
**Цель:** Научиться создавать кастомные дашборды в Grafana

**Практическая важность:** Дашборды обеспечивают визуализацию состояния кластера и приложений, позволяя быстро оценить производительность и выявить проблемы. Кастомные дашборды адаптированы под конкретные потребности команды и являются основой для принятия операционных решений и планирования ресурсов.

**Задачи:**
1. Создайте дашборд с метриками кластера
2. Добавьте графики использования ресурсов
3. Настройте временные диапазоны

**Инструкции:**
1. Откройте Grafana (http://localhost:3000)
2. Создайте новый дашборд
3. Добавьте панели:
   - CPU использование: `100 - (avg by(instance) (irate(node_cpu_seconds_total{mode="idle"}[5m])) * 100)`
   - Память: `(node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / node_memory_MemTotal_bytes * 100`
   - Количество подов: `count(kube_pod_info)`
   - Состояние узлов: `kube_node_status_condition`

---

## Уровень 5: Автоматизация и масштабирование

### Упражнение 5.1: Horizontal Pod Autoscaler
**Цель:** Научиться автоматически масштабировать приложения

**Практическая важность:** HPA автоматически адаптирует количество реплик приложения под текущую нагрузку, обеспечивая оптимальное использование ресурсов и высокую доступность. Это критично для обработки пиковых нагрузок, экономии ресурсов и обеспечения SLA. Автоматическое масштабирование - ключевая особенность облачных нативных приложений.

**Задачи:**
1. Создайте приложение с нагрузкой
2. Настройте HPA
3. Протестируйте автоматическое масштабирование

**Команды для выполнения:**
```bash
# Приложение с нагрузкой
kubectl create deployment load-test --image=busybox --replicas=1 -n exercise-1
kubectl patch deployment load-test -n exercise-1 -p '{"spec":{"template":{"spec":{"containers":[{"name":"busybox","command":["sh","-c","while true; do echo \"Generating load...\"; dd if=/dev/zero of=/dev/null bs=1M count=1000; sleep 10; done"],"resources":{"requests":{"cpu":"100m","memory":"128Mi"},"limits":{"cpu":"500m","memory":"256Mi"}}}]}}}}'

# HPA
kubectl autoscale deployment load-test --cpu-percent=50 --min=1 --max=5 -n exercise-1

# Мониторинг
kubectl get hpa -n exercise-1 -w
```

---

### Упражнение 5.2: Job и CronJob
**Цель:** Понять разницу между долгоживущими и кратковременными задачами

**Практическая важность:** Job и CronJob решают задачи пакетной обработки, резервного копирования, очистки данных и других периодических операций. Они обеспечивают надежное выполнение задач с возможностью повторных попыток и мониторинга. Это основа для автоматизации операционных задач и интеграции с внешними системами.

**Задачи:**
1. Создайте Job для однократной задачи
2. Создайте CronJob для периодических задач
3. Проверьте выполнение

**Команды для выполнения:**
```bash
# Job
kubectl create job backup-job --image=busybox -n exercise-1 -- sh -c "echo 'Backup completed at $(date)' && sleep 10"

# CronJob
kubectl create cronjob cleanup-job --image=busybox -n exercise-1 --schedule="*/5 * * * *" -- sh -c "echo 'Cleanup at $(date)'"

# Проверка
kubectl get jobs -n exercise-1
kubectl get cronjobs -n exercise-1
```

---

## Проверочные вопросы

### Теоретические вопросы:
1. В чем разница между Pod и Deployment?
2. Как работает Service типа LoadBalancer?
3. Что такое PersistentVolume и зачем он нужен?
4. Как HPA определяет, когда масштабировать приложение?
5. В чем преимущества StatefulSet перед Deployment?

### Практические задачи:
1. Создайте приложение с 3 репликами, которое автоматически масштабируется при нагрузке
2. Настройте мониторинг этого приложения с алертами
3. Создайте резервную копию данных приложения
4. Настройте сетевую политику для изоляции трафика
5. Создайте дашборд в Grafana для мониторинга приложения

---

## Дополнительные упражнения для углубленного изучения

### Упражнение 6.1: Настройка RBAC
**Практическая важность:** RBAC обеспечивает безопасность кластера, контролируя доступ пользователей и сервисов к ресурсам. Это критично для соответствия требованиям безопасности, аудита и разделения ответственности в командах. Правильная настройка RBAC предотвращает несанкционированный доступ и минимизирует риски.

### Упражнение 6.2: Создание кастомного оператора
**Практическая важность:** Операторы расширяют возможности Kubernetes для управления сложными приложениями. Они автоматизируют операции, специфичные для конкретных приложений, и обеспечивают их надежную работу. Это основа для создания собственных платформ и автоматизации бизнес-процессов.

### Упражнение 6.3: Настройка GitOps с ArgoCD
**Практическая важность:** GitOps обеспечивает декларативное управление инфраструктурой через Git, обеспечивая версионность, аудит и автоматизацию развертываний. Это современный подход к DevOps, который повышает надежность, скорость и безопасность доставки приложений.

---

## Решения и подсказки

### Подсказка 1: Отладка проблем
```bash
# Проверка событий
kubectl get events --sort-by='.lastTimestamp' -n <namespace>

# Логи пода
kubectl logs <pod-name> -n <namespace>

# Описание ресурса
kubectl describe <resource-type> <resource-name> -n <namespace>
```

### Подсказка 2: Полезные команды
```bash
# Получение YAML ресурса
kubectl get <resource> <name> -o yaml

# Редактирование ресурса
kubectl edit <resource> <name>

# Масштабирование
kubectl scale deployment <name> --replicas=<number>
```

### Подсказка 3: Мониторинг
```bash
# Просмотр ресурсов в реальном времени
kubectl get pods -w

# Мониторинг логов
kubectl logs -f <pod-name>

# Проверка метрик
kubectl top pods
kubectl top nodes
```

---

## Дополнительные ресурсы

- [Kubernetes.io Tasks](https://kubernetes.io/docs/tasks/)
- [Kubernetes Examples](https://github.com/kubernetes/examples)
- [Kubernetes The Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)
- [Killer.sh Practice Exams](https://killer.sh/)

Удачи в изучении Kubernetes! 🚀
