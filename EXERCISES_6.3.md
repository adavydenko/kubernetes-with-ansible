# Упражнение 6.3: Настройка GitOps с ArgoCD

## 🎯 Цель упражнения
Научиться настраивать и использовать GitOps подход с ArgoCD для автоматического развертывания приложений в Kubernetes, используя Git как единственный источник истины.

## 📋 Практическая важность
GitOps обеспечивает декларативное управление инфраструктурой через Git, обеспечивая версионность, аудит и автоматизацию развертываний. Это современный подход к DevOps, который повышает надежность, скорость и безопасность доставки приложений.

## 🔧 Предварительные требования
- Работающий Kubernetes кластер
- kubectl настроен и подключен к кластеру
- Git репозиторий (GitHub, GitLab, Bitbucket)
- Helm установлен (опционально)

---

## 📚 Теоретическая база

### Что такое GitOps:
GitOps - это практика управления инфраструктурой и приложениями, где Git является единственным источником истины для желаемого состояния системы. Изменения в Git автоматически применяются к кластеру.

### Принципы GitOps:
1. **Декларативное описание** - все конфигурации описаны декларативно
2. **Версионность** - все изменения версионированы в Git
3. **Автоматическое применение** - изменения автоматически применяются
4. **Аудит и соответствие** - полная история изменений

### Компоненты ArgoCD:
- **ArgoCD Server** - веб-интерфейс и API
- **Application Controller** - контроллер приложений
- **Repo Server** - сервер для работы с Git репозиториями
- **ApplicationSet Controller** - для массового создания приложений

---

## 🚀 Практические задания

### Задание 1: Установка ArgoCD
**Практическая важность:** Установка ArgoCD является первым шагом к реализации GitOps практик. Это критично для создания автоматизированной системы развертывания, где Git становится единственным источником истины, обеспечивая версионность, аудит и повторяемость всех изменений инфраструктуры.

#### Шаг 1: Создание namespace для ArgoCD
```bash
kubectl create namespace argocd
```

#### Шаг 2: Установка ArgoCD
```bash
# Добавление Helm репозитория
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

# Установка ArgoCD
helm install argocd argo/argo-cd \
  --namespace argocd \
  --set server.extraArgs="{--insecure}" \
  --set server.ingress.enabled=true \
  --set server.ingress.hosts[0]=argocd.local \
  --set server.ingress.ingressClassName=nginx \
  --wait --timeout=10m
```

#### Шаг 3: Получение пароля администратора
```bash
# Получение пароля
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d

# Альтернативный способ
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

#### Шаг 4: Доступ к веб-интерфейсу
```bash
# Проброс порта
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Откройте http://localhost:8080
# Логин: admin
# Пароль: полученный выше
```

### Задание 2: Создание Git репозитория для приложений
**Практическая важность:** Структурированный Git репозиторий является основой GitOps практик, обеспечивая организацию конфигураций по окружениям и приложениям. Это критично для масштабируемости, поддержки множественных команд и обеспечения согласованности развертываний в различных средах.

#### Шаг 1: Структура репозитория
```bash
# Создание структуры репозитория
mkdir gitops-demo
cd gitops-demo

# Создание структуры директорий
mkdir -p apps/nginx/{base,overlays/{dev,staging,prod}}
mkdir -p apps/redis/{base,overlays/{dev,staging,prod}}
mkdir -p apps/postgres/{base,overlays/{dev,staging,prod}}
mkdir -p argocd/applications
```

#### Шаг 2: Создание базовых манифестов для nginx
```bash
# Создание базового deployment
cat <<EOF > apps/nginx/base/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
        resources:
          requests:
            memory: "64Mi"
            cpu: "250m"
          limits:
            memory: "128Mi"
            cpu: "500m"
EOF

# Создание базового service
cat <<EOF > apps/nginx/base/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx
spec:
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
  type: ClusterIP
EOF

# Создание kustomization.yaml
cat <<EOF > apps/nginx/base/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

resources:
- deployment.yaml
- service.yaml

commonLabels:
  app: nginx
EOF
```

#### Шаг 3: Создание overlay для dev окружения
```bash
# Создание kustomization для dev
cat <<EOF > apps/nginx/overlays/dev/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: dev
bases:
- ../../base

patchesStrategicMerge:
- deployment-patch.yaml

commonLabels:
  environment: dev
EOF

# Создание патча для dev
cat <<EOF > apps/nginx/overlays/dev/deployment-patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 1
  template:
    spec:
      containers:
      - name: nginx
        resources:
          requests:
            memory: "32Mi"
            cpu: "100m"
          limits:
            memory: "64Mi"
            cpu: "200m"
EOF
```

#### Шаг 4: Создание overlay для prod окружения
```bash
# Создание kustomization для prod
cat <<EOF > apps/nginx/overlays/prod/kustomization.yaml
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization

namespace: prod
bases:
- ../../base

patchesStrategicMerge:
- deployment-patch.yaml

commonLabels:
  environment: prod
EOF

# Создание патча для prod
cat <<EOF > apps/nginx/overlays/prod/deployment-patch.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  template:
    spec:
      containers:
      - name: nginx
        resources:
          requests:
            memory: "128Mi"
            cpu: "500m"
          limits:
            memory: "256Mi"
            cpu: "1000m"
EOF
```

### Задание 3: Создание ApplicationSet для автоматического развертывания
**Практическая важность:** ApplicationSet автоматизирует создание множественных приложений ArgoCD, что критично для управления большим количеством окружений и приложений. Это обеспечивает масштабируемость GitOps практик и снижает ручную работу при развертывании в множественных средах.

#### Шаг 1: Создание ApplicationSet
```bash
# Создание ApplicationSet для nginx
cat <<EOF > argocd/applications/nginx-applicationset.yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: nginx-apps
  namespace: argocd
spec:
  generators:
  - list:
      elements:
      - env: dev
        namespace: dev
        replicas: "1"
      - env: staging
        namespace: staging
        replicas: "2"
      - env: prod
        namespace: prod
        replicas: "3"
  
  template:
    metadata:
      name: 'nginx-{{env}}'
      namespace: argocd
    spec:
      project: default
      source:
        repoURL: https://github.com/your-username/gitops-demo
        targetRevision: HEAD
        path: apps/nginx/overlays/{{env}}
      destination:
        server: https://kubernetes.default.svc
        namespace: '{{namespace}}'
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
        syncOptions:
        - CreateNamespace=true
        - PrunePropagationPolicy=foreground
        - PruneLast=true
      revisionHistoryLimit: 5
EOF
```

#### Шаг 2: Создание Application для Redis
```bash
# Создание Application для Redis
cat <<EOF > argocd/applications/redis-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: redis-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-username/gitops-demo
    targetRevision: HEAD
    path: apps/redis/overlays/dev
  destination:
    server: https://kubernetes.default.svc
    namespace: dev
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - PrunePropagationPolicy=foreground
    - PruneLast=true
  revisionHistoryLimit: 5
EOF
```

### Задание 4: Настройка мониторинга и алертов
**Практическая важность:** Интеграция мониторинга в GitOps обеспечивает полную наблюдаемость развертываний и состояния приложений. Это критично для проактивного обнаружения проблем, обеспечения соответствия SLA и создания надежной системы эксплуатации с автоматическими реакциями на инциденты.

#### Шаг 1: Создание Application для мониторинга
```bash
# Создание Application для Prometheus
cat <<EOF > argocd/applications/monitoring-app.yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: monitoring
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/your-username/gitops-demo
    targetRevision: HEAD
    path: apps/monitoring
  destination:
    server: https://kubernetes.default.svc
    namespace: monitoring
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
    syncOptions:
    - CreateNamespace=true
    - PrunePropagationPolicy=foreground
    - PruneLast=true
  revisionHistoryLimit: 5
EOF
```

#### Шаг 2: Создание манифестов для мониторинга
```bash
# Создание директории для мониторинга
mkdir -p apps/monitoring

# Создание ServiceMonitor для nginx
cat <<EOF > apps/monitoring/servicemonitor-nginx.yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: nginx-monitor
  namespace: monitoring
spec:
  selector:
    matchLabels:
      app: nginx
  endpoints:
  - port: http
    interval: 30s
EOF
```

### Задание 5: Настройка RBAC для ArgoCD
**Практическая важность:** RBAC для ArgoCD обеспечивает безопасность системы развертывания, контролируя доступ к ресурсам кластера. Это критично для соответствия требованиям безопасности, аудита и разделения ответственности в командах, особенно в корпоративных средах с множественными командами.

#### Шаг 1: Создание ServiceAccount для ArgoCD
```bash
# Создание ServiceAccount
cat <<EOF > argocd/rbac/argocd-sa.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: argocd-application-controller
  namespace: argocd
EOF
```

#### Шаг 2: Создание ClusterRole для ArgoCD
```bash
# Создание ClusterRole
cat <<EOF > argocd/rbac/argocd-clusterrole.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: argocd-application-controller
rules:
- apiGroups:
  - '*'
  resources:
  - '*'
  verbs:
  - '*'
- nonResourceURLs:
  - '*'
  verbs:
  - '*'
EOF
```

#### Шаг 3: Создание ClusterRoleBinding
```bash
# Создание ClusterRoleBinding
cat <<EOF > argocd/rbac/argocd-clusterrolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: argocd-application-controller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: argocd-application-controller
subjects:
- kind: ServiceAccount
  name: argocd-application-controller
  namespace: argocd
EOF
```

---

## 🔍 Тестирование и проверка

### Проверка установки ArgoCD
```bash
# Проверка подов ArgoCD
kubectl get pods -n argocd

# Проверка сервисов
kubectl get svc -n argocd

# Проверка ingress
kubectl get ingress -n argocd
```

### Применение приложений
```bash
# Применение ApplicationSet
kubectl apply -f argocd/applications/nginx-applicationset.yaml

# Применение отдельных приложений
kubectl apply -f argocd/applications/redis-app.yaml
kubectl apply -f argocd/applications/monitoring-app.yaml

# Проверка созданных приложений
kubectl get applications -n argocd
```

### Проверка синхронизации
```bash
# Проверка статуса синхронизации
kubectl get applications -n argocd -o wide

# Проверка ресурсов в dev namespace
kubectl get all -n dev

# Проверка ресурсов в prod namespace
kubectl get all -n prod
```

---

## 🛠️ Продвинутые настройки

### Настройка уведомлений
```bash
# Создание ConfigMap для уведомлений
cat <<EOF > argocd/notifications/argocd-notifications-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
  namespace: argocd
data:
  service.slack: |
    token: $slack-token
  template.app-sync-succeeded: |
    message: |
      Application {{.app.metadata.name}} sync succeeded.
      Environment: {{.app.spec.destination.namespace}}
      Revision: {{.app.status.sync.revision}}
  trigger.on-sync-succeeded: |
    - when: app.status.operationState.phase in ['Succeeded']
      send: [app-sync-succeeded]
EOF
```

### Настройка SSO
```bash
# Создание ConfigMap для SSO
cat <<EOF > argocd/sso/argocd-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
  namespace: argocd
data:
  url: https://argocd.your-domain.com
  admin.enabled: "false"
  dex.config: |
    connectors:
    - type: github
      id: github
      name: GitHub
      config:
        clientID: your-github-client-id
        clientSecret: your-github-client-secret
        orgs:
        - name: your-org
EOF
```

---

## 📝 Дополнительные задания

### Задание 6: Создание Helm chart для приложения (Самостоятельная работа)
**Практическая важность:** Helm charts обеспечивают шаблонизацию и версионирование приложений, что критично для управления сложными приложениями с множественными компонентами. Это упрощает развертывание, обеспечивает повторяемость и позволяет эффективно управлять конфигурациями для разных окружений.

#### 🎯 Задача
Создайте Helm chart для вашего приложения с поддержкой разных окружений и автоматизации.

#### 📋 Требования
- Шаблонизация манифестов
- Values файлы для разных окружений (dev, staging, prod)
- Hooks для миграций базы данных
- Тесты для chart
- Документация и README

#### 💡 Подсказки
1. **Создайте базовую структуру chart:**
   ```bash
   # Создание нового chart
   helm create my-app
   cd my-app
   
   # Структура chart
   tree .
   ```

2. **Используйте шаблонизацию:**
   ```yaml
   # В templates/deployment.yaml
   apiVersion: apps/v1
   kind: Deployment
   metadata:
     name: {{ include "my-app.fullname" . }}
   spec:
     replicas: {{ .Values.replicaCount }}
   ```

3. **Создайте values для окружений:**
   ```bash
   # values-dev.yaml
   replicaCount: 1
   resources:
     limits:
       memory: "128Mi"
   
   # values-prod.yaml
   replicaCount: 3
   resources:
     limits:
       memory: "512Mi"
   ```

#### 🔗 Полезные ресурсы
- [Helm Documentation](https://helm.sh/docs/)
- [Helm Chart Template Guide](https://helm.sh/docs/chart_template_guide/)
- [Helm Hooks](https://helm.sh/docs/topics/charts_hooks/)
- [Helm Testing](https://helm.sh/docs/topics/chart_tests/)
- [Helm Best Practices](https://helm.sh/docs/chart_best_practices/)

#### ✅ Критерии успеха
- [ ] Chart создан и работает
- [ ] Values файлы для всех окружений
- [ ] Hooks для миграций реализованы
- [ ] Тесты chart написаны и проходят
- [ ] Документация создана
- [ ] Chart протестирован в ArgoCD

### Задание 7: Настройка автоматического тестирования (Самостоятельная работа)
**Практическая важность:** Автоматическое тестирование в GitOps обеспечивает качество и надежность развертываний, предотвращая попадание проблем в продакшен. Это критично для создания надежного процесса доставки, снижения рисков и обеспечения быстрого и безопасного развертывания изменений.

#### 🎯 Задача
Настройте автоматическое тестирование для GitOps pipeline с интеграцией CI/CD.

#### 📋 Требования
- ArgoCD ApplicationSet с тестовыми окружениями
- Интеграция с CI/CD pipeline (GitHub Actions, GitLab CI)
- Автоматическое создание pull requests
- Тестирование перед merge
- Автоматическое развертывание в тестовую среду

#### 💡 Подсказки
1. **Создайте тестовое окружение:**
   ```yaml
   # argocd/applications/test-applicationset.yaml
   apiVersion: argoproj.io/v1alpha1
   kind: ApplicationSet
   metadata:
     name: test-apps
   spec:
     generators:
     - list:
         elements:
         - env: test
           namespace: test
   ```

2. **Настройте GitHub Actions:**
   ```yaml
   # .github/workflows/test-deploy.yml
   name: Test and Deploy
   on:
     push:
       branches: [main]
   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
       - uses: actions/checkout@v2
       - name: Run tests
         run: |
           kubectl apply -f k8s/test/
           kubectl wait --for=condition=ready pod -l app=test-app
   ```

3. **Используйте ArgoCD CLI для тестирования:**
   ```bash
   # Тестирование синхронизации
   argocd app sync test-app
   argocd app wait test-app --health
   ```

#### 🔗 Полезные ресурсы
- [ArgoCD Testing Strategies](https://argo-cd.readthedocs.io/en/stable/operator-manual/application_management/#testing)
- [GitHub Actions for Kubernetes](https://github.com/actions-runner-controller/actions-runner-controller)
- [GitLab CI for ArgoCD](https://docs.gitlab.com/ee/user/clusters/agent/gitops/)
- [ArgoCD ApplicationSet Testing](https://argocd-applicationset.readthedocs.io/en/stable/Getting-Started/)
- [Kubernetes Testing Tools](https://kubernetes.io/docs/tasks/debug-application-cluster/debug-application/)

#### ✅ Критерии успеха
- [ ] Тестовое окружение настроено
- [ ] CI/CD pipeline интегрирован
- [ ] Автоматические тесты работают
- [ ] Pull requests создаются автоматически
- [ ] Тестирование перед merge настроено
- [ ] Процесс документирован

### Задание 8: Создание дашборда для мониторинга (Самостоятельная работа)
**Практическая важность:** Дашборды для мониторинга GitOps обеспечивают видимость состояния развертываний и производительности системы. Это критично для оперативного управления, быстрого реагирования на проблемы и обеспечения прозрачности процессов для всех участников команды.

#### 🎯 Задача
Создайте комплексный дашборд для мониторинга GitOps процессов и состояния приложений.

#### 📋 Требования
- Статус синхронизации приложений ArgoCD
- История развертываний и откатов
- Метрики производительности кластера
- Алерты и уведомления
- Интеграция с Grafana
- Экспорт метрик в Prometheus

#### 💡 Подсказки
1. **Используйте ArgoCD Metrics:**
   ```bash
   # Включите метрики в ArgoCD
   kubectl patch deployment argocd-server -n argocd -p '{"spec":{"template":{"spec":{"containers":[{"name":"argocd-server","args":["--metrics-port","8083"]}]}}}}'
   
   # Проверьте метрики
   kubectl port-forward svc/argocd-server -n argocd 8083:8083
   curl http://localhost:8083/metrics
   ```

2. **Создайте ServiceMonitor для ArgoCD:**
   ```yaml
   # monitoring/argocd-servicemonitor.yaml
   apiVersion: monitoring.coreos.com/v1
   kind: ServiceMonitor
   metadata:
     name: argocd-server
     namespace: monitoring
   spec:
     selector:
       matchLabels:
         app.kubernetes.io/name: argocd-server
     endpoints:
     - port: metrics
       interval: 30s
   ```

3. **Настройте Grafana Dashboard:**
   ```json
   {
     "dashboard": {
       "title": "ArgoCD GitOps Dashboard",
       "panels": [
         {
           "title": "Application Sync Status",
           "type": "stat",
           "targets": [
             {
               "expr": "argocd_app_sync_total"
             }
           ]
         }
       ]
     }
   }
   ```

#### 🔗 Полезные ресурсы
- [ArgoCD Metrics](https://argo-cd.readthedocs.io/en/stable/operator-manual/metrics/)
- [Grafana ArgoCD Dashboard](https://grafana.com/grafana/dashboards/14584)
- [Prometheus ArgoCD Exporter](https://github.com/argoproj-labs/argocd-exporter)
- [ArgoCD Notifications](https://argocd-notifications.readthedocs.io/)
- [Kubernetes Dashboard Integration](https://kubernetes.io/docs/tasks/access-application-cluster/web-ui-dashboard/)

#### ✅ Критерии успеха
- [ ] Метрики ArgoCD настроены
- [ ] ServiceMonitor создан
- [ ] Grafana дашборд создан
- [ ] Алерты настроены
- [ ] Уведомления работают
- [ ] Дашборд доступен команде

---

## 🔗 Полезные ресурсы

- [ArgoCD Documentation](https://argo-cd.readthedocs.io/)
- [GitOps Best Practices](https://www.gitops.tech/)
- [ArgoCD Examples](https://github.com/argoproj/argocd-example-apps)
- [Kustomize Documentation](https://kustomize.io/)

---

## ✅ Проверочные вопросы

1. Что такое GitOps и каковы его принципы?
2. Как ArgoCD синхронизирует состояние кластера с Git?
3. В чем разница между Application и ApplicationSet?
4. Как настроить автоматическую синхронизацию в ArgoCD?
5. Какие преимущества дает использование Kustomize с ArgoCD?

---

Удачи в изучении GitOps! 🚀
