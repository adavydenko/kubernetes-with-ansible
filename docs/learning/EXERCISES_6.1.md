# Упражнение 6.1: Настройка RBAC (Role-Based Access Control)

## 🎯 Цель упражнения
Научиться настраивать и управлять доступом к ресурсам Kubernetes с помощью RBAC, создавая роли, привязки и учетные записи сервисов.

## 📋 Практическая важность
RBAC обеспечивает безопасность кластера, контролируя доступ пользователей и сервисов к ресурсам. Это критично для соответствия требованиям безопасности, аудита и разделения ответственности в командах. Правильная настройка RBAC предотвращает несанкционированный доступ и минимизирует риски.

## 🔧 Предварительные требования
- Работающий Kubernetes кластер
- Права администратора кластера
- kubectl настроен и подключен к кластеру

---

## 📚 Теоретическая база

### Основные компоненты RBAC:
- **Role/ClusterRole** - определяет набор разрешений
- **RoleBinding/ClusterRoleBinding** - связывает роли с пользователями/группами/ServiceAccount
- **ServiceAccount** - учетная запись для подов

### Типы ролей:
- **Role** - действует в рамках namespace
- **ClusterRole** - действует на уровне кластера

### Типы привязок:
- **RoleBinding** - связывает Role с субъектами в namespace
- **ClusterRoleBinding** - связывает ClusterRole с субъектами в кластере

---

## 🚀 Практические задания

### Задание 1: Создание базовых ролей и привязок
**Практическая важность:** Базовые роли и привязки - фундамент безопасности Kubernetes. Это упражнение учит создавать минимальные права доступа для конкретных задач, что критично для предотвращения несанкционированного доступа и соблюдения принципа минимальных привилегий в продакшен-средах.

#### Шаг 1: Создание namespace для упражнения
```bash
kubectl create namespace rbac-exercise
```

#### Шаг 2: Создание Role для чтения подов
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: rbac-exercise
  name: pod-reader
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
EOF
```

#### Шаг 3: Создание ServiceAccount
```bash
kubectl create serviceaccount pod-reader-sa -n rbac-exercise
```

#### Шаг 4: Создание RoleBinding
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: rbac-exercise
subjects:
- kind: ServiceAccount
  name: pod-reader-sa
  namespace: rbac-exercise
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
EOF
```

#### Шаг 5: Тестирование доступа
```bash
# Создаем тестовый под с ServiceAccount
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
  namespace: rbac-exercise
spec:
  serviceAccountName: pod-reader-sa
  containers:
  - name: test-container
    image: busybox
    command: ['sh', '-c', 'kubectl get pods -n rbac-exercise; sleep 3600']
    resources:
      requests:
        memory: "64Mi"
        cpu: "100m"
      limits:
        memory: "128Mi"
        cpu: "200m"
EOF

# Проверяем логи
kubectl logs test-pod -n rbac-exercise
```

### Задание 2: Создание ClusterRole для мониторинга
**Практическая важность:** ClusterRole для мониторинга позволяет системам наблюдения (Prometheus, Grafana) безопасно собирать метрики со всего кластера. Это критично для обеспечения видимости состояния инфраструктуры без предоставления избыточных прав доступа, что является стандартной практикой в корпоративных средах.

#### Шаг 1: Создание ClusterRole
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: monitoring-reader
rules:
- apiGroups: [""]
  resources: ["pods", "services", "nodes"]
  verbs: ["get", "list", "watch"]
- apiGroups: ["metrics.k8s.io"]
  resources: ["pods", "nodes"]
  verbs: ["get", "list", "watch"]
EOF
```

#### Шаг 2: Создание ClusterRoleBinding
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: monitoring-reader-binding
subjects:
- kind: ServiceAccount
  name: monitoring-sa
  namespace: rbac-exercise
roleRef:
  kind: ClusterRole
  name: monitoring-reader
  apiGroup: rbac.authorization.k8s.io
EOF
```

#### Шаг 3: Создание ServiceAccount
```bash
kubectl create serviceaccount monitoring-sa -n rbac-exercise
```

### Задание 3: Создание роли для разработчиков
**Практическая важность:** Роли для разработчиков обеспечивают баланс между продуктивностью и безопасностью. Разработчики получают необходимые права для развертывания и отладки приложений, но без доступа к критически важным системным ресурсам. Это основа для DevOps практик и командной работы в Kubernetes.

#### Шаг 1: Создание Role для разработчиков
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: rbac-exercise
  name: developer-role
rules:
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets"]
  verbs: ["get", "list", "watch", "create", "update", "patch", "delete"]
- apiGroups: [""]
  resources: ["pods/log"]
  verbs: ["get", "list"]
EOF
```

#### Шаг 2: Создание RoleBinding для группы пользователей
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: developer-binding
  namespace: rbac-exercise
subjects:
- kind: Group
  name: developers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: developer-role
  apiGroup: rbac.authorization.k8s.io
EOF
```

### Задание 4: Создание роли для администраторов namespace
**Практическая важность:** Роли для администраторов namespace обеспечивают децентрализованное управление кластером, позволяя командам самостоятельно управлять своими ресурсами. Это критично для масштабирования операций, соответствия требованиям безопасности и реализации принципа разделения ответственности в крупных организациях.

#### Шаг 1: Создание ClusterRole для администраторов namespace
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: namespace-admin
rules:
- apiGroups: [""]
  resources: ["namespaces"]
  verbs: ["get", "list", "watch"]
- apiGroups: [""]
  resources: ["pods", "services", "configmaps", "secrets", "persistentvolumeclaims"]
  verbs: ["*"]
- apiGroups: ["apps"]
  resources: ["deployments", "replicasets", "statefulsets", "daemonsets"]
  verbs: ["*"]
- apiGroups: ["networking.k8s.io"]
  resources: ["networkpolicies"]
  verbs: ["*"]
EOF
```

#### Шаг 2: Создание ClusterRoleBinding
```bash
cat <<EOF | kubectl apply -f -
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: namespace-admin-binding
subjects:
- kind: User
  name: namespace-admin@example.com
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: namespace-admin
  apiGroup: rbac.authorization.k8s.io
EOF
```

---

## 🔍 Проверка и тестирование

### Проверка созданных ресурсов
```bash
# Проверка ролей
kubectl get roles -n rbac-exercise
kubectl get clusterroles | grep -E "(monitoring-reader|namespace-admin)"

# Проверка привязок
kubectl get rolebindings -n rbac-exercise
kubectl get clusterrolebindings | grep -E "(monitoring-reader|namespace-admin)"

# Проверка ServiceAccount
kubectl get serviceaccounts -n rbac-exercise
```

### Тестирование доступа
```bash
# Тест доступа к подам
kubectl auth can-i get pods --as=system:serviceaccount:rbac-exercise:pod-reader-sa -n rbac-exercise

# Тест доступа к узлам
kubectl auth can-i get nodes --as=system:serviceaccount:rbac-exercise:monitoring-sa

# Тест создания подов
kubectl auth can-i create pods --as=system:serviceaccount:rbac-exercise:pod-reader-sa -n rbac-exercise
```

### Создание тестового приложения
```bash
# Создание deployment
kubectl create deployment test-app --image=nginx:alpine -n rbac-exercise

# Создание сервиса
kubectl expose deployment test-app --port=80 -n rbac-exercise

# Проверка доступа с разных ServiceAccount
kubectl run test-access --image=busybox --serviceaccount=pod-reader-sa -n rbac-exercise --rm -it --restart=Never --overrides='{"spec":{"containers":[{"name":"test-access","resources":{"requests":{"memory":"64Mi","cpu":"100m"},"limits":{"memory":"128Mi","cpu":"200m"}}}]}}' -- sh -c "kubectl get pods -n rbac-exercise"
```

---

## 🛡️ Безопасность и лучшие практики

### Принципы безопасности:
1. **Принцип минимальных привилегий** - давайте только необходимые права
2. **Регулярный аудит** - проверяйте права доступа
3. **Разделение ответственности** - разные роли для разных задач
4. **Документирование** - ведите учет всех ролей и привязок

### Рекомендации:
```bash
# Регулярная проверка прав
kubectl get clusterrolebindings -o wide
kubectl get rolebindings --all-namespaces

# Аудит доступа
kubectl auth can-i --list --as=system:serviceaccount:rbac-exercise:pod-reader-sa -n rbac-exercise

# Проверка неиспользуемых ролей
kubectl get roles --all-namespaces -o yaml | grep -A 5 "name:"
```

---

## 🧹 Очистка ресурсов

```bash
# Удаление namespace (удалит все ресурсы)
kubectl delete namespace rbac-exercise

# Удаление ClusterRole и ClusterRoleBinding
kubectl delete clusterrole monitoring-reader
kubectl delete clusterrole namespace-admin
kubectl delete clusterrolebinding monitoring-reader-binding
kubectl delete clusterrolebinding namespace-admin-binding
```

---

## 📝 Дополнительные задания

### Задание 5: Создание роли для CI/CD (Самостоятельная работа)
**Практическая важность:** Роли для CI/CD систем автоматизируют процесс развертывания, обеспечивая безопасность и повторяемость. Это критично для реализации непрерывной доставки, где автоматизированные системы должны иметь минимальные необходимые права для выполнения своих задач без риска компрометации кластера.

#### 🎯 Задача
Создайте роль, которая позволяет CI/CD системе безопасно развертывать приложения.

#### 📋 Требования
- Развертывать приложения в определенном namespace
- Обновлять ConfigMap и Secret
- Читать логи подов
- Масштабировать deployments
- Создавать и обновлять Service
- Управлять Ingress ресурсами

#### 💡 Подсказки
1. **Начните с анализа необходимых ресурсов:**
   ```bash
   # Какие ресурсы нужны для развертывания?
   kubectl api-resources --verbs=create,update,patch,delete
   ```

2. **Изучите существующие роли:**
   ```bash
   # Посмотрите на встроенные роли
   kubectl get clusterroles | grep -E "(edit|admin)"
   kubectl describe clusterrole edit
   ```

3. **Проверьте права доступа:**
   ```bash
   # Тестируйте права с помощью can-i
   kubectl auth can-i create deployments --as=system:serviceaccount:ci-cd:jenkins
   ```

#### 🔗 Полезные ресурсы
- [RBAC для CI/CD систем](https://kubernetes.io/docs/concepts/security/rbac-good-practices/#rbac-for-ci-cd-systems)
- [Jenkins Kubernetes Plugin RBAC](https://github.com/jenkinsci/kubernetes-plugin#rbac)
- [GitLab Runner RBAC](https://docs.gitlab.com/runner/install/kubernetes.html#rbac)
- [GitHub Actions RBAC](https://github.com/actions-runner-controller/actions-runner-controller/blob/master/docs/authenticating-to-the-kubernetes-api.md)

#### ✅ Критерии успеха
- [ ] Роль создана и протестирована
- [ ] ServiceAccount создан и привязан к роли
- [ ] CI/CD система может успешно развертывать приложения
- [ ] Права ограничены только необходимыми ресурсами
- [ ] Документированы все созданные ресурсы

### Задание 6: Создание роли для мониторинга (Самостоятельная работа)
**Практическая важность:** Специализированные роли для мониторинга обеспечивают детальную видимость состояния кластера и приложений без предоставления избыточных прав. Это критично для создания надежных систем наблюдения, которые могут обнаруживать проблемы на ранней стадии и обеспечивать соответствие требованиям аудита и соответствия.

#### 🎯 Задача
Создайте роль для Prometheus, которая обеспечивает безопасный доступ к метрикам и событиям кластера.

#### 📋 Требования
- Читать метрики узлов и подов
- Доступ к API Kubernetes для service discovery
- Читать события кластера
- Доступ к Custom Resource для ServiceMonitor
- Читать логи подов (опционально)

#### 💡 Подсказки
1. **Изучите существующие роли мониторинга:**
   ```bash
   # Посмотрите на роли Prometheus Operator
   kubectl get clusterroles | grep -i prometheus
   kubectl describe clusterrole prometheus-k8s
   ```

2. **Анализируйте необходимые API группы:**
   ```bash
   # Какие API группы нужны для мониторинга?
   kubectl api-resources --api-group=metrics.k8s.io
   kubectl api-resources --api-group=monitoring.coreos.com
   ```

3. **Проверьте права для метрик:**
   ```bash
   # Тестируйте доступ к метрикам
   kubectl auth can-i get pods --as=system:serviceaccount:monitoring:prometheus -n kube-system
   kubectl auth can-i get nodes --as=system:serviceaccount:monitoring:prometheus
   ```

#### 🔗 Полезные ресурсы
- [Prometheus RBAC Configuration](https://prometheus-operator.dev/docs/kube-prometheus-on-kubeadm/#rbac)
- [Kubernetes Metrics Server RBAC](https://github.com/kubernetes-sigs/metrics-server#rbac)
- [Prometheus Operator RBAC](https://github.com/prometheus-operator/prometheus-operator/blob/main/Documentation/rbac.md)
- [ServiceMonitor RBAC](https://prometheus-operator.dev/docs/operator/rbac/)

#### ✅ Критерии успеха
- [ ] Роль создана с минимальными необходимыми правами
- [ ] Prometheus может собирать метрики узлов и подов
- [ ] Service discovery работает корректно
- [ ] Доступ к событиям кластера настроен
- [ ] Роль протестирована и документирована

### Задание 7: Создание роли для резервного копирования (Самостоятельная работа)
**Практическая важность:** Роли для резервного копирования обеспечивают защиту критически важных данных без риска их компрометации. Это критично для соблюдения требований по защите данных, обеспечения непрерывности бизнеса и соответствия нормативным требованиям в различных отраслях.

#### 🎯 Задача
Создайте роль для системы резервного копирования, которая обеспечивает безопасное создание и восстановление резервных копий.

#### 📋 Требования
- Чтение PersistentVolumeClaim
- Создание и удаление временных подов
- Доступ к ConfigMap и Secret
- Создание и управление Job для резервного копирования
- Доступ к StorageClass для создания временных томов

#### 💡 Подсказки
1. **Анализируйте ресурсы для резервного копирования:**
   ```bash
   # Какие ресурсы нужны для резервного копирования?
   kubectl api-resources --verbs=create,get,list,delete | grep -E "(pods|jobs|pvc|configmap|secret)"
   ```

2. **Изучите паттерны резервного копирования:**
   ```bash
   # Посмотрите на существующие Job для резервного копирования
   kubectl get jobs --all-namespaces | grep -i backup
   kubectl describe job backup-postgres -n database
   ```

3. **Проверьте права для работы с томами:**
   ```bash
   # Тестируйте доступ к PVC и StorageClass
   kubectl auth can-i get persistentvolumeclaims --as=system:serviceaccount:backup:velero
   kubectl auth can-i create jobs --as=system:serviceaccount:backup:velero
   ```

#### 🔗 Полезные ресурсы
- [Velero RBAC Configuration](https://velero.io/docs/v1.9/rbac/)
- [Kubernetes Backup Strategies](https://kubernetes.io/docs/concepts/storage/volumes/#backup)
- [Restic Integration RBAC](https://velero.io/docs/v1.9/restic/)
- [Backup Job Patterns](https://kubernetes.io/docs/concepts/workloads/controllers/job/)

#### ✅ Критерии успеха
- [ ] Роль создана с правами только для резервного копирования
- [ ] Система может создавать резервные копии PVC
- [ ] Временные поды создаются и удаляются корректно
- [ ] Job для резервного копирования работает
- [ ] Роль протестирована и документирована

---

## 🔗 Полезные ресурсы

- [Kubernetes RBAC Documentation](https://kubernetes.io/docs/reference/access-authn-authz/rbac/)
- [RBAC Best Practices](https://kubernetes.io/docs/concepts/security/rbac-good-practices/)
- [RBAC Examples](https://kubernetes.io/docs/reference/access-authn-authz/rbac/#role-examples)

---

## ✅ Проверочные вопросы

1. В чем разница между Role и ClusterRole?
2. Когда использовать RoleBinding, а когда ClusterRoleBinding?
3. Как проверить права доступа пользователя или ServiceAccount?
4. Какие принципы безопасности следует соблюдать при настройке RBAC?
5. Как создать роль для чтения только определенных ресурсов в namespace?

---

Удачи в изучении RBAC! 🔐
