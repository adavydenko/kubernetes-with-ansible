# Упражнение 6.2: Создание кастомного оператора

## 🎯 Цель упражнения
Научиться создавать кастомные операторы Kubernetes для автоматизации управления сложными приложениями, используя Operator SDK и Go.

## 📋 Практическая важность
Операторы расширяют возможности Kubernetes для управления сложными приложениями. Они автоматизируют операции, специфичные для конкретных приложений, и обеспечивают их надежную работу. Это основа для создания собственных платформ и автоматизации бизнес-процессов.

## 🔧 Предварительные требования
- Работающий Kubernetes кластер
- Go 1.19+ установлен
- Operator SDK CLI установлен
- Docker установлен и настроен
- kubectl настроен и подключен к кластеру

---

## 📚 Теоретическая база

### Что такое оператор:
Оператор - это паттерн автоматизации, который расширяет Kubernetes для управления приложениями и их компонентами. Операторы следуют принципам Kubernetes:
- **Декларативное управление** - описывают желаемое состояние
- **Контроллеры** - приводят текущее состояние к желаемому
- **Реактивность** - реагируют на изменения

### Компоненты оператора:
- **Custom Resource Definition (CRD)** - определяет новый тип ресурса
- **Custom Resource (CR)** - экземпляр нового типа ресурса
- **Controller** - логика управления ресурсом
- **Reconciler** - функция приведения состояния в соответствие

---

## 🚀 Практические задания

### Задание 1: Создание простого оператора для веб-приложения
**Практическая важность:** Создание оператора для веб-приложения демонстрирует основы паттерна операторов и автоматизации управления приложениями. Это критично для понимания того, как расширять возможности Kubernetes для специфичных бизнес-требований и создания собственных платформ управления приложениями.

#### Шаг 1: Установка Operator SDK
```bash
# Установка Operator SDK
curl -L https://github.com/operator-framework/operator-sdk/releases/download/v1.28.0/operator-sdk_linux_amd64 -o operator-sdk
chmod +x operator-sdk
sudo mv operator-sdk /usr/local/bin/

# Альтернативная установка через Go
# go install github.com/operator-framework/operator-sdk/cmd/operator-sdk@latest

# Проверка установки
operator-sdk version
```

#### Шаг 2: Создание нового оператора
```bash
# Создание директории для проекта
mkdir webapp-operator
cd webapp-operator

# Инициализация оператора
operator-sdk init --domain example.com --repo github.com/example/webapp-operator

# Создание API для WebApp
operator-sdk create api --group webapp --version v1alpha1 --kind WebApp
```

#### Шаг 3: Определение структуры Custom Resource
```bash
# Редактирование файла api/v1alpha1/webapp_types.go
cat <<'EOF' > api/v1alpha1/webapp_types.go
package v1alpha1

import (
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// WebAppSpec определяет желаемое состояние WebApp
type WebAppSpec struct {
    // Replicas - количество реплик приложения
    Replicas int32 `json:"replicas"`
    
    // Image - Docker образ приложения
    Image string `json:"image"`
    
    // Port - порт, на котором работает приложение
    Port int32 `json:"port"`
    
    // Environment - переменные окружения
    Environment map[string]string `json:"environment,omitempty"`
}

// WebAppStatus определяет наблюдаемое состояние WebApp
type WebAppStatus struct {
    // AvailableReplicas - количество доступных реплик
    AvailableReplicas int32 `json:"availableReplicas"`
    
    // Phase - фаза приложения (Pending, Running, Failed)
    Phase string `json:"phase"`
    
    // Message - сообщение о состоянии
    Message string `json:"message,omitempty"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// WebApp - это схема для API WebApp
type WebApp struct {
    metav1.TypeMeta   `json:",inline"`
    metav1.ObjectMeta `json:"metadata,omitempty"`

    Spec   WebAppSpec   `json:"spec,omitempty"`
    Status WebAppStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// WebAppList содержит список WebApp
type WebAppList struct {
    metav1.TypeMeta `json:",inline"`
    metav1.ListMeta `json:"metadata,omitempty"`
    Items           []WebApp `json:"items"`
}

func init() {
    SchemeBuilder.Register(&WebApp{}, &WebAppList{})
}
EOF
```

#### Шаг 4: Реализация контроллера
```bash
# Редактирование файла controllers/webapp_controller.go
cat <<'EOF' > controllers/webapp_controller.go
package controllers

import (
    "context"
    "fmt"
    "reflect"

    appsv1 "k8s.io/api/apps/v1"
    corev1 "k8s.io/api/core/v1"
    "k8s.io/apimachinery/pkg/api/errors"
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
    "k8s.io/apimachinery/pkg/runtime"
    "k8s.io/apimachinery/pkg/types"
    ctrl "sigs.k8s.io/controller-runtime"
    "sigs.k8s.io/controller-runtime/pkg/client"
    "sigs.k8s.io/controller-runtime/pkg/log"

    webappv1alpha1 "github.com/example/webapp-operator/api/v1alpha1"
)

// WebAppReconciler reconciles a WebApp object
type WebAppReconciler struct {
    client.Client
    Scheme *runtime.Scheme
}

//+kubebuilder:rbac:groups=webapp.example.com,resources=webapps,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=webapp.example.com,resources=webapps/status,verbs=get;update;patch
//+kubebuilder:rbac:groups=apps,resources=deployments,verbs=get;list;watch;create;update;patch;delete
//+kubebuilder:rbac:groups=core,resources=services,verbs=get;list;watch;create;update;patch;delete

// Reconcile обрабатывает WebApp ресурсы
func (r *WebAppReconciler) Reconcile(ctx context.Context, req ctrl.Request) (ctrl.Result, error) {
    logger := log.FromContext(ctx)

    // Получение WebApp ресурса
    webapp := &webappv1alpha1.WebApp{}
    err := r.Get(ctx, req.NamespacedName, webapp)
    if err != nil {
        if errors.IsNotFound(err) {
            return ctrl.Result{}, nil
        }
        return ctrl.Result{}, err
    }

    // Проверка существования Deployment
    deployment := &appsv1.Deployment{}
    err = r.Get(ctx, types.NamespacedName{Name: webapp.Name, Namespace: webapp.Namespace}, deployment)
    if err != nil && errors.IsNotFound(err) {
        // Создание Deployment
        deployment = r.createDeployment(webapp)
        err = r.Create(ctx, deployment)
        if err != nil {
            logger.Error(err, "Failed to create Deployment")
            return ctrl.Result{}, err
        }
        logger.Info("Created Deployment", "name", deployment.Name)
    } else if err != nil {
        return ctrl.Result{}, err
    }

    // Проверка существования Service
    service := &corev1.Service{}
    err = r.Get(ctx, types.NamespacedName{Name: webapp.Name, Namespace: webapp.Namespace}, service)
    if err != nil && errors.IsNotFound(err) {
        // Создание Service
        service = r.createService(webapp)
        err = r.Create(ctx, service)
        if err != nil {
            logger.Error(err, "Failed to create Service")
            return ctrl.Result{}, err
        }
        logger.Info("Created Service", "name", service.Name)
    } else if err != nil {
        return ctrl.Result{}, err
    }

    // Обновление статуса
    if deployment.Status.AvailableReplicas == webapp.Spec.Replicas {
        webapp.Status.Phase = "Running"
        webapp.Status.AvailableReplicas = deployment.Status.AvailableReplicas
        webapp.Status.Message = "All replicas are available"
    } else {
        webapp.Status.Phase = "Pending"
        webapp.Status.AvailableReplicas = deployment.Status.AvailableReplicas
        webapp.Status.Message = fmt.Sprintf("Available replicas: %d/%d", deployment.Status.AvailableReplicas, webapp.Spec.Replicas)
    }

    err = r.Status().Update(ctx, webapp)
    if err != nil {
        return ctrl.Result{}, err
    }

    return ctrl.Result{}, nil
}

// createDeployment создает Deployment для WebApp
func (r *WebAppReconciler) createDeployment(webapp *webappv1alpha1.WebApp) *appsv1.Deployment {
    labels := map[string]string{
        "app": webapp.Name,
    }

    deployment := &appsv1.Deployment{
        ObjectMeta: metav1.ObjectMeta{
            Name:      webapp.Name,
            Namespace: webapp.Namespace,
        },
        Spec: appsv1.DeploymentSpec{
            Replicas: &webapp.Spec.Replicas,
            Selector: &metav1.LabelSelector{
                MatchLabels: labels,
            },
            Template: corev1.PodTemplateSpec{
                ObjectMeta: metav1.ObjectMeta{
                    Labels: labels,
                },
                Spec: corev1.PodSpec{
                    Containers: []corev1.Container{{
                        Image: webapp.Spec.Image,
                        Name:  webapp.Name,
                        Ports: []corev1.ContainerPort{{
                            ContainerPort: webapp.Spec.Port,
                        }},
                        Env: r.createEnvVars(webapp),
                    }},
                },
            },
        },
    }

    ctrl.SetControllerReference(webapp, deployment, r.Scheme)
    return deployment
}

// createService создает Service для WebApp
func (r *WebAppReconciler) createService(webapp *webappv1alpha1.WebApp) *corev1.Service {
    labels := map[string]string{
        "app": webapp.Name,
    }

    service := &corev1.Service{
        ObjectMeta: metav1.ObjectMeta{
            Name:      webapp.Name,
            Namespace: webapp.Namespace,
        },
        Spec: corev1.ServiceSpec{
            Selector: labels,
            Ports: []corev1.ServicePort{{
                Port:       webapp.Spec.Port,
                TargetPort: int32(webapp.Spec.Port),
            }},
            Type: corev1.ServiceTypeClusterIP,
        },
    }

    ctrl.SetControllerReference(webapp, service, r.Scheme)
    return service
}

// createEnvVars создает переменные окружения из WebApp spec
func (r *WebAppReconciler) createEnvVars(webapp *webappv1alpha1.WebApp) []corev1.EnvVar {
    var envVars []corev1.EnvVar
    for key, value := range webapp.Spec.Environment {
        envVars = append(envVars, corev1.EnvVar{
            Name:  key,
            Value: value,
        })
    }
    return envVars
}

// SetupWithManager настраивает контроллер с менеджером
func (r *WebAppReconciler) SetupWithManager(mgr ctrl.Manager) error {
    return ctrl.NewControllerManagedBy(mgr).
        For(&webappv1alpha1.WebApp{}).
        Owns(&appsv1.Deployment{}).
        Owns(&corev1.Service{}).
        Complete(r)
}
EOF
```

#### Шаг 5: Сборка и установка оператора
```bash
# Генерация кода
make generate

# Сборка манифестов
make manifests

# Сборка оператора
make build

# Установка CRD
make install

# Запуск оператора локально
make run
```

### Задание 2: Создание Custom Resource
**Практическая важность:** Custom Resource позволяет создавать доменно-специфичные объекты Kubernetes, которые инкапсулируют сложную логику приложения в простых декларативных манифестах. Это критично для упрощения управления сложными приложениями и создания понятных интерфейсов для команд разработки и эксплуатации.

#### Шаг 1: Создание примера WebApp
```bash
# Создание файла config/samples/webapp_v1alpha1_webapp.yaml
mkdir -p config/samples
cat <<EOF > config/samples/webapp_v1alpha1_webapp.yaml
apiVersion: webapp.example.com/v1alpha1
kind: WebApp
metadata:
  name: webapp-sample
spec:
  replicas: 3
  image: nginx:alpine
  port: 80
  environment:
    NGINX_HOST: "example.com"
    NGINX_PORT: "80"
EOF
```

#### Шаг 2: Применение Custom Resource
```bash
# Применение CRD
kubectl apply -f config/crd/bases/

# Применение примера WebApp
kubectl apply -f config/samples/webapp_v1alpha1_webapp.yaml

# Проверка создания ресурсов
kubectl get webapp
kubectl get deployment
kubectl get service
```

### Задание 3: Создание оператора для базы данных
**Практическая важность:** Операторы для баз данных решают сложные задачи управления stateful приложениями, включая миграции, резервное копирование и масштабирование. Это критично для обеспечения надежности и автоматизации операций с критически важными данными в продакшен-средах.

#### Шаг 1: Создание нового оператора для PostgreSQL
```bash
# Создание нового проекта
mkdir postgres-operator
cd postgres-operator

# Инициализация оператора
operator-sdk init --domain example.com --repo github.com/example/postgres-operator

# Создание API для PostgreSQL
operator-sdk create api --group database --version v1alpha1 --kind PostgreSQL
```

#### Шаг 2: Определение структуры PostgreSQL CR
```bash
# Редактирование api/v1alpha1/postgresql_types.go
cat <<'EOF' > api/v1alpha1/postgresql_types.go
package v1alpha1

import (
    metav1 "k8s.io/apimachinery/pkg/apis/meta/v1"
)

// PostgreSQLSpec определяет желаемое состояние PostgreSQL
type PostgreSQLSpec struct {
    // Replicas - количество реплик PostgreSQL
    Replicas int32 `json:"replicas"`
    
    // Image - Docker образ PostgreSQL
    Image string `json:"image"`
    
    // Database - имя базы данных
    Database string `json:"database"`
    
    // Username - имя пользователя
    Username string `json:"username"`
    
    // PasswordSecret - имя Secret с паролем
    PasswordSecret string `json:"passwordSecret"`
    
    // Storage - размер хранилища
    Storage string `json:"storage"`
    
    // StorageClass - класс хранилища
    StorageClass string `json:"storageClass,omitempty"`
}

// PostgreSQLStatus определяет наблюдаемое состояние PostgreSQL
type PostgreSQLStatus struct {
    // AvailableReplicas - количество доступных реплик
    AvailableReplicas int32 `json:"availableReplicas"`
    
    // Phase - фаза базы данных
    Phase string `json:"phase"`
    
    // Message - сообщение о состоянии
    Message string `json:"message,omitempty"`
    
    // Endpoint - endpoint для подключения
    Endpoint string `json:"endpoint,omitempty"`
}

//+kubebuilder:object:root=true
//+kubebuilder:subresource:status

// PostgreSQL - это схема для API PostgreSQL
type PostgreSQL struct {
    metav1.TypeMeta   `json:",inline"`
    metav1.ObjectMeta `json:"metadata,omitempty"`

    Spec   PostgreSQLSpec   `json:"spec,omitempty"`
    Status PostgreSQLStatus `json:"status,omitempty"`
}

//+kubebuilder:object:root=true

// PostgreSQLList содержит список PostgreSQL
type PostgreSQLList struct {
    metav1.TypeMeta `json:",inline"`
    metav1.ListMeta `json:"metadata,omitempty"`
    Items           []PostgreSQL `json:"items"`
}

func init() {
    SchemeBuilder.Register(&PostgreSQL{}, &PostgreSQLList{})
}
EOF
```

---

## 🔍 Тестирование оператора

### Проверка работы WebApp оператора
```bash
# Проверка CRD
kubectl get crd | grep webapp

# Создание WebApp
kubectl apply -f config/samples/webapp_v1alpha1_webapp.yaml

# Проверка статуса
kubectl get webapp webapp-sample -o yaml

# Проверка созданных ресурсов
kubectl get deployment webapp-sample
kubectl get service webapp-sample

# Проверка логов оператора
kubectl logs -f deployment/webapp-operator-controller-manager -n webapp-operator-system
```

### Тестирование масштабирования
```bash
# Масштабирование WebApp
kubectl patch webapp webapp-sample --type='merge' -p='{"spec":{"replicas":5}}'

# Проверка изменения
kubectl get deployment webapp-sample
kubectl get webapp webapp-sample -o jsonpath='{.status.availableReplicas}'
```

---

## 🛠️ Создание Docker образа

### Сборка образа
```bash
# Создание Dockerfile
cat <<EOF > Dockerfile
FROM golang:1.19 as builder

WORKDIR /workspace
COPY go.mod go.mod
COPY go.sum go.sum
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o manager main.go

FROM gcr.io/distroless/static:nonroot
WORKDIR /
COPY --from=builder /workspace/manager .
USER 65532:65532

ENTRYPOINT ["/manager"]
EOF

# Сборка образа
docker build -t webapp-operator:v0.1.0 .

# Тегирование и отправка в registry
docker tag webapp-operator:v0.1.0 your-registry/webapp-operator:v0.1.0
docker push your-registry/webapp-operator:v0.1.0
```

---

## 📝 Дополнительные задания

### Задание 4: Добавление валидации (Самостоятельная работа)
**Практическая важность:** Валидация в CRD предотвращает создание некорректных ресурсов и обеспечивает целостность данных. Это критично для предотвращения ошибок конфигурации, улучшения пользовательского опыта и обеспечения надежности операций в продакшен-средах.

#### 🎯 Задача
Добавьте валидацию в WebApp CRD для обеспечения корректности данных.

#### 📋 Требования
- Проверка, что replicas > 0
- Проверка, что port в диапазоне 1-65535
- Проверка формата Docker образа
- Валидация обязательных полей
- Проверка формата переменных окружения

#### 💡 Подсказки
1. **Изучите синтаксис валидации:**
   ```bash
   # Посмотрите на существующие CRD с валидацией
   kubectl get crd deployments.apps -o yaml | grep -A 20 "openAPIV3Schema"
   ```

2. **Используйте kubebuilder маркеры:**
   ```go
   // +kubebuilder:validation:Minimum=1
   // +kubebuilder:validation:Maximum=65535
   Port int32 `json:"port"`
   ```

3. **Добавьте регулярные выражения:**
   ```go
   // +kubebuilder:validation:Pattern=`^[a-zA-Z0-9][a-zA-Z0-9-_.]*[a-zA-Z0-9]$`
   Image string `json:"image"`
   ```

#### 🔗 Полезные ресурсы
- [Kubebuilder Validation Markers](https://book.kubebuilder.io/reference/markers/crd-validation.html)
- [OpenAPI Schema Validation](https://kubernetes.io/docs/tasks/extend-kubernetes/custom-resources/custom-resource-definitions/#validation)
- [CRD Validation Examples](https://github.com/kubernetes-sigs/kubebuilder/tree/master/docs/book/src/cronjob-tutorial/testdata/project)
- [Docker Image Validation](https://github.com/distribution/distribution/blob/main/reference/reference.go)

#### ✅ Критерии успеха
- [ ] Валидация replicas работает корректно
- [ ] Валидация port проверяет диапазон
- [ ] Валидация Docker образа работает
- [ ] Обязательные поля помечены как required
- [ ] CRD обновлен и протестирован

### Задание 5: Добавление финайзеров (Самостоятельная работа)
**Практическая важность:** Финайзеры обеспечивают корректную очистку ресурсов при удалении Custom Resource, предотвращая утечки ресурсов и орфанные объекты. Это критично для поддержания чистоты кластера, управления ресурсами и предотвращения конфликтов при повторном создании ресурсов.

#### 🎯 Задача
Создайте финайзер для автоматической очистки ресурсов при удалении WebApp.

#### 📋 Требования
- Удаление связанных ConfigMap
- Очистка PersistentVolumeClaim
- Удаление ServiceAccount
- Очистка Ingress ресурсов
- Удаление HPA (Horizontal Pod Autoscaler)

#### 💡 Подсказки
1. **Изучите паттерн финайзеров:**
   ```go
   // Добавьте финайзер в метаданные
   finalizers:
   - webapp.example.com/finalizer
   ```

2. **Реализуйте логику финайзера:**
   ```go
   // В контроллере добавьте проверку финайзера
   if webapp.DeletionTimestamp != nil {
       // Логика очистки
   }
   ```

3. **Удалите финайзер после очистки:**
   ```go
   // Удалите финайзер из метаданных
   controllerutil.RemoveFinalizer(webapp, "webapp.example.com/finalizer")
   ```

#### 🔗 Полезные ресурсы
- [Kubernetes Finalizers](https://kubernetes.io/docs/concepts/overview/working-with-objects/finalizers/)
- [Kubebuilder Finalizers](https://book.kubebuilder.io/reference/using-finalizers.html)
- [Controller Runtime Finalizers](https://pkg.go.dev/sigs.k8s.io/controller-runtime/pkg/controllerutil#RemoveFinalizer)
- [Finalizer Examples](https://github.com/kubernetes-sigs/kubebuilder/tree/master/docs/book/src/cronjob-tutorial/testdata/project)

#### ✅ Критерии успеха
- [ ] Финайзер добавлен в CRD
- [ ] Логика очистки реализована
- [ ] Все связанные ресурсы удаляются
- [ ] Финайзер корректно удаляется после очистки
- [ ] Протестировано удаление WebApp

### Задание 6: Создание оператора для Redis (Самостоятельная работа)
**Практическая важность:** Операторы для кэш-систем решают сложные задачи управления состоянием, кластеризации и производительности. Это критично для создания высоконадежных систем кэширования, которые могут автоматически масштабироваться и восстанавливаться после сбоев в продакшен-средах.

#### 🎯 Задача
Создайте полнофункциональный оператор для Redis с поддержкой кластеризации и мониторинга.

#### 📋 Требования
- Кластеризация Redis (Redis Cluster)
- Персистентное хранилище
- Мониторинг через Prometheus
- Резервное копирование
- Автоматическое масштабирование
- Управление конфигурацией

#### 💡 Подсказки
1. **Изучите существующие Redis операторы:**
   ```bash
   # Посмотрите на Redis Operator от Spotahome
   kubectl get crd | grep redis
   kubectl describe crd redisclusters.redis.spotahome.com
   ```

2. **Анализируйте архитектуру Redis Cluster:**
   ```bash
   # Изучите компоненты Redis Cluster
   redis-cli --cluster help
   redis-cli --cluster info 127.0.0.1:7000
   ```

3. **Используйте StatefulSet для кластеризации:**
   ```yaml
   # StatefulSet обеспечивает стабильные идентификаторы
   apiVersion: apps/v1
   kind: StatefulSet
   metadata:
     name: redis-cluster
   spec:
     serviceName: redis-cluster
     replicas: 6
   ```

#### 🔗 Полезные ресурсы
- [Redis Operator by Spotahome](https://github.com/spotahome/redis-operator)
- [Redis Cluster Specification](https://redis.io/topics/cluster-spec)
- [Redis Cluster Tutorial](https://redis.io/topics/cluster-tutorial)
- [Prometheus Redis Exporter](https://github.com/oliver006/redis_exporter)
- [Redis Backup Strategies](https://redis.io/topics/persistence)

#### ✅ Критерии успеха
- [ ] CRD для Redis Cluster создан
- [ ] Контроллер управляет кластером
- [ ] Персистентное хранилище настроено
- [ ] Мониторинг интегрирован
- [ ] Резервное копирование работает
- [ ] Оператор протестирован

---

## 🔗 Полезные ресурсы

- [Operator SDK Documentation](https://sdk.operatorframework.io/)
- [Kubernetes Operator Pattern](https://kubernetes.io/docs/concepts/extend-kubernetes/operator/)
- [Operator Best Practices](https://sdk.operatorframework.io/docs/best-practices/)
- [Kubebuilder Book](https://book.kubebuilder.io/)

---

## ✅ Проверочные вопросы

1. Что такое оператор в контексте Kubernetes?
2. Какие компоненты входят в состав оператора?
3. В чем разница между CRD и CR?
4. Как оператор приводит текущее состояние к желаемому?
5. Какие инструменты используются для создания операторов?

---

Удачи в создании операторов! 🤖
