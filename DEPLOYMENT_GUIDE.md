# Руководство по развертыванию кластера Kubernetes с MetalLB

Это руководство предоставляет пошаговые инструкции по развертыванию полного кластера Kubernetes с балансировщиком нагрузки MetalLB с использованием Ansible.

## Предварительные требования

### Системные требования
- **Управляющий узел**: Ubuntu Desktop 24.10 или аналогичный
- **Узлы кластера**: Ubuntu Server 24.04 LTS
- **ОЗУ**: Минимум 2 ГБ на узел (рекомендуется 4 ГБ)
- **ЦП**: 2 ядра на узел (рекомендуется 4 ядра)
- **Хранилище**: 20 ГБ на узел
- **Сеть**: Все узлы должны находиться в одной L2 сети

### Требования к программному обеспечению
- Ansible 2.14+
- VirtualBox 7.0+ (для развертывания на виртуальных машинах)
- SSH доступ между всеми узлами

## Конфигурация сети

### Схема IP-адресов
```
Управляющий узел:    10.0.2.15
Мастер-узел:         10.0.2.5
Рабочий узел 1:      10.0.2.6
Рабочий узел 2:      10.0.2.7
...
Рабочий узел N:      10.0.2.(5+N)

Пул MetalLB:         10.0.2.240 - 10.0.2.250
```

### Требования к сети
- Все узлы должны иметь возможность взаимодействовать друг с другом
- Порт 22 (SSH) должен быть открыт между узлами
- Порты Kubernetes (6443, 2379-2380, 10250-10252) должны быть доступны
- MetalLB требует L2 сетевого подключения

## Пошаговое развертывание

### 1. Подготовка виртуальных машин

#### Создание управляющего узла
```bash
# Создать виртуальную машину Ubuntu Desktop
# - Имя: control
# - IP: 10.0.2.15
# - ОЗУ: 2 ГБ
# - Хранилище: 20 ГБ
```

#### Создание мастер-узла
```bash
# Создать виртуальную машину Ubuntu Server
# - Имя: kube-master
# - IP: 10.0.2.5
# - ОЗУ: 4 ГБ
# - Хранилище: 30 ГБ
```

#### Создание рабочих узлов
```bash
# Создать виртуальные машины Ubuntu Server
# - Имена: kube-worker-01, kube-worker-02, и т.д.
# - IP: 10.0.2.6, 10.0.2.7, и т.д.
# - ОЗУ: 4 ГБ каждая
# - Хранилище: 30 ГБ каждая
```

### 2. Настройка управляющего узла

#### Установка Ansible
```bash
sudo apt update
sudo apt install ansible -y
```

#### Настройка SSH ключей
```bash
# Сгенерировать SSH ключ
ssh-keygen -t rsa -b 4096 -C "ansible@control"

# Скопировать ключи на все узлы
ssh-copy-id user@10.0.2.5  # master
ssh-copy-id user@10.0.2.6  # worker-01
ssh-copy-id user@10.0.2.7  # worker-02
# ... повторить для всех рабочих узлов
```

#### Клонирование репозитория
```bash
git clone <repository-url>
cd kubernetes-with-ansible
```

### 3. Настройка инвентаря

Отредактируйте `inventory.yml` в соответствии с вашей средой:

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
        # Добавьте больше рабочих узлов по необходимости
```

### 4. Настройка конфигурации (необязательно)

#### Изменение пула IP-адресов MetalLB
Отредактируйте `metallb/defaults/main.yml`:

```yaml
metallb_ip_pool:
  - start: "10.0.2.240"
    end: "10.0.2.250"
    name: "first-pool"
```

#### Изменение демонстрационного приложения
Отредактируйте `demo_app/defaults/main.yml`:

```yaml
demo_app:
  name: "my-app"
  namespace: "production"
  replicas: 5
  image: "my-app:latest"
  port: 8080
```

### 5. Развертывание кластера

#### Полное развертывание
```bash
# Развернуть полный кластер с MetalLB
ansible-playbook -i inventory.yml site.yml
```

#### Пошаговое развертывание
```bash
# Развернуть только мастер-узел
ansible-playbook -i inventory.yml site.yml --limit master_nodes

# Развернуть сеть (Flannel)
ansible-playbook -i inventory.yml site.yml --tags kubernetes_network

# Развернуть рабочие узлы
ansible-playbook -i inventory.yml site.yml --limit worker_nodes

# Развернуть MetalLB
ansible-playbook -i inventory.yml site.yml --tags metallb

# Развернуть демонстрационное приложение
ansible-playbook -i inventory.yml site.yml --tags demo_app
```

### 6. Проверка развертывания

#### Проверка состояния кластера
```bash
# SSH к мастер-узлу
ssh user@10.0.2.5

# Проверить узлы кластера
kubectl get nodes

# Проверить все поды
kubectl get pods --all-namespaces
```

#### Проверка установки MetalLB
```bash
# Проверить пространство имен MetalLB
kubectl get namespace metallb-system

# Проверить поды MetalLB
kubectl get pods -n metallb-system

# Проверить пулы IP-адресов
kubectl get ipaddresspools -n metallb-system

# Проверить L2 объявления
kubectl get l2advertisements -n metallb-system
```

#### Тестирование функциональности LoadBalancer
```bash
# Запустить тестовый скрипт
./scripts/test-metallb.sh

# Или протестировать вручную
kubectl get service nginx-demo-service -n demo
curl http://<EXTERNAL_IP>
```

## Конфигурация после развертывания

### 1. Настройка kubectl на управляющем узле

```bash
# Скопировать kubeconfig с мастера
scp user@10.0.2.5:/etc/kubernetes/admin.conf ~/.kube/config

# Установить права доступа
chmod 600 ~/.kube/config

# Протестировать подключение
kubectl get nodes
```

### 2. Установка дополнительных инструментов (необязательно)

#### Установка Helm
```bash
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
```

#### Установка kubectl
```bash
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
```

### 3. Настройка мониторинга (необязательно)

#### Установка Prometheus Operator
```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/kube-prometheus-stack
```

#### Установка Grafana
```bash
helm repo add grafana https://grafana.github.io/helm-charts
helm install grafana grafana/grafana
```

## Устранение неполадок

### Распространенные проблемы

#### 1. Узлы не присоединяются к кластеру
```bash
# Проверить команду присоединения на мастере
kubeadm token create --print-join-command

# Проверить логи kubelet на рабочем узле
sudo journalctl -u kubelet -f
```

#### 2. MetalLB не назначает IP-адреса
```bash
# Проверить логи MetalLB
kubectl logs -n metallb-system -l app=metallb -c controller
kubectl logs -n metallb-system -l app=metallb -c speaker

# Проверить конфигурацию пула IP-адресов
kubectl get ipaddresspools -n metallb-system -o yaml
```

#### 3. Проблемы с сетевым подключением
```bash
# Протестировать подключение между узлами
ping 10.0.2.5  # с рабочего узла на мастер
ping 10.0.2.6  # с мастера на рабочий узел

# Проверить поды Flannel
kubectl get pods -n kube-flannel
```

### Команды отладки

```bash
# Проверить события кластера
kubectl get events --sort-by='.lastTimestamp'

# Проверить ресурсы узла
kubectl describe node <node-name>

# Проверить детали пода
kubectl describe pod <pod-name> -n <namespace>

# Проверить детали сервиса
kubectl describe service <service-name> -n <namespace>
```

## Обслуживание

### Резервное копирование конфигурации

```bash
# Резервное копирование конфигурации кластера
kubectl get all --all-namespaces -o yaml > cluster-backup.yaml

# Резервное копирование конфигурации MetalLB
kubectl get ipaddresspools -n metallb-system -o yaml > metallb-ip-pools.yaml
kubectl get l2advertisements -n metallb-system -o yaml > metallb-l2-adv.yaml
```

### Обновление кластера

```bash
# Обновить MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.12/config/manifests/metallb-native.yaml

# Обновить Kubernetes
kubectl drain <node-name> --ignore-daemonsets
# Обновить узел
kubectl uncordon <node-name>
```

### Масштабирование кластера

#### Добавление рабочего узла
1. Создать новую ВМ с Ubuntu Server 24.04
2. Добавить в инвентарь
3. Запустить развертывание рабочего узла:
```bash
ansible-playbook -i inventory.yml site.yml --limit new-worker-node
```

#### Удаление рабочего узла
```bash
# Остановить узел
kubectl drain <node-name> --ignore-daemonsets --delete-emptydir-data

# Удалить из кластера
kubectl delete node <node-name>
```

## Вопросы безопасности

### 1. Сетевая безопасность
- Реализовать сетевые политики
- Использовать правила файрвола
- Мониторить сетевой трафик

### 2. Контроль доступа
- Использовать RBAC для доступа пользователей
- Реализовать сервисные аккаунты
- Регулярные обновления безопасности

### 3. Мониторинг
- Мониторить ресурсы кластера
- Настроить оповещения
- Регулярные резервные копии

## Оптимизация производительности

### 1. Распределение ресурсов
- Мониторить использование ЦП и памяти
- Настроить лимиты ресурсов
- Оптимизировать размещение подов

### 2. Сетевая оптимизация
- Использовать соответствующие настройки CNI
- Оптимизировать конфигурацию MetalLB
- Мониторить сетевую задержку

### 3. Оптимизация хранилища
- Использовать соответствующие классы хранилища
- Мониторить использование диска
- Реализовать политики хранилища

## Поддержка и ресурсы

### Документация
- [Документация Kubernetes](https://kubernetes.io/docs/)
- [Документация MetalLB](https://metallb.universe.tf/)
- [Документация Ansible](https://docs.ansible.com/)

### Сообщество
- [Kubernetes Slack](https://slack.k8s.io/)
- [MetalLB GitHub](https://github.com/metallb/metallb)
- [Сообщество Ansible](https://docs.ansible.com/ansible/latest/community/)

### Мониторинг и логирование
- Настроить централизованное логирование
- Реализовать панели мониторинга
- Настроить правила оповещений
