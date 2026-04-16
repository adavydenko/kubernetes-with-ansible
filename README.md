# Kubernetes кластер с Ansible, MetalLB, Local Storage и Monitoring

Репозиторий содержит Ansible роли для автоматизированного развертывания Kubernetes кластера с дополнительными компонентами и полный набор учебных материалов для изучения Kubernetes.

## 📁 Структура проекта

```
kubernetes-with-ansible/
├── ansible/                          # 🚀 Ansible автоматизация
│   ├── playbooks/                    # Playbooks для развертывания
│   │   ├── site.yml                  # Основной playbook
│   │   ├── site_gpu_nodes.yml        # GPU playbook
│   │   └── inventory.yml             # Инвентарь хостов
│   ├── roles/                        # Ansible роли
│   │   ├── kubernetes_master/        # Настройка master узла
│   │   ├── kubernetes_worker/        # Настройка worker узлов
│   │   ├── kubernetes_network/        # Сетевая настройка (Flannel)
│   │   ├── metallb/                  # MetalLB Load Balancer
│   │   ├── storage/                  # Local Storage Provisioner
│   │   ├── monitoring/               # Prometheus + Grafana
│   │   └── demo_app/                 # Демо-приложение
│   ├── scripts/                      # Скрипты тестирования и валидации
│   └── examples/                     # Примеры конфигураций
├── docs/                            # 📚 Документация и учебные материалы
│   ├── getting-started/              # Быстрые старты
│   ├── deployment/                   # Руководства по развертыванию
│   ├── components/                   # Документация по компонентам
│   │   ├── metallb/                  # MetalLB документация
│   │   ├── storage/                  # Local Storage документация
│   │   ├── monitoring/               # Monitoring документация
│   │   └── gpu/                      # GPU поддержка
│   ├── learning/                     # Учебные материалы
│   ├── theory/                       # Теоретические материалы
│   └── reference/                    # Справочные материалы
└── README.md                         # Этот файл
```

## Учебное пособие (mdBook)

Исходники книги лежат в [`docs/`](docs/): [`docs/book.toml`](docs/book.toml), [`docs/SUMMARY.md`](docs/SUMMARY.md), контент в подкаталогах.

### Локальная сборка HTML (Docker)

Из корня репозитория:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\build-mdbook.ps1 -RebuildImage
```

Результат: `docs/book/` (откройте `docs/book/index.html` в браузере).

### Публикация на GitHub Pages

Workflow [`.github/workflows/mdbook.yml`](.github/workflows/mdbook.yml) собирает книгу и публикует сайт при пуше в `main`. В настройках репозитория включите **Pages** с источником **GitHub Actions**.

### PDF

Workflow [`.github/workflows/mdbook-pdf.yml`](.github/workflows/mdbook-pdf.yml) запускается при пуше в `main` и вручную (**Actions → mdBook PDF → Run workflow**). Он собирает `study-guide.pdf` из `docs/book/print.html` и прикладывает артефакт **study-guide-pdf** к прогону (вкладка Actions → выбранный run → Artifacts).

## 🚀 Быстрый старт

### 1. Подготовка окружения

```bash
# Установка Ansible
sudo apt update && sudo apt install ansible -y

# Клонирование репозитория
git clone <repository-url>
cd kubernetes-with-ansible

# Настройка SSH ключей
ssh-keygen -t rsa -b 4096 -C "ansible@control"
ssh-copy-id user@10.0.2.5  # master
ssh-copy-id user@10.0.2.6  # worker-01
ssh-copy-id user@10.0.2.7  # worker-02
```

### 2. Настройка inventory

Отредактируйте `ansible/playbooks/inventory.yml`:

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
```

### 3. Развертывание кластера

```bash
# Переход в директорию ansible
cd ansible

# Полное развертывание кластера с MetalLB, Local Storage и Monitoring
ansible-playbook -i playbooks/inventory.yml playbooks/site.yml
```

### 4. Проверка результатов

```bash
# Подключение к master узлу
ssh user@10.0.2.5

# Проверка кластера
kubectl get nodes
kubectl get pods --all-namespaces

# Проверка MetalLB
kubectl get pods -n metallb-system

# Проверка демо-приложения
kubectl get service -n demo
curl http://10.0.2.240
```

## 🏗 Архитектура кластера

### Системные требования

1. **Системные требования:**
   - Control Node: Ubuntu Desktop 24.10 (2GB RAM, 20GB диска)
   - Master Node: Ubuntu Server 24.04 LTS (4GB RAM, 30GB диска)
   - Worker Nodes: Ubuntu Server 24.04 LTS (4GB RAM, 30GB диска каждый)
   - Все узлы в одной L2 сети

2. **Сетевая схема:**
   ```
   Control Node:    10.0.2.15
   Master Node:     10.0.2.5
   Worker Node 1:   10.0.2.6
   Worker Node 2:   10.0.2.7
   ...
   MetalLB Pool:    10.0.2.240 - 10.0.2.250
   ```

3. **Программное обеспечение:**
   - Ansible 2.14+
   - SSH доступ между всеми узлами

### Настройка окружений

Мы создаем 2 группы ресурсов:
1. **Управляющий контур (control node)** - машина для запуска Ansible
2. **K8s контур** - мастер и рабочие ноды Kubernetes кластера

Control node ответственен за настройку всех узлов k8s кластера и организации самого кластера.

### VMs

Следующие виртуальные машины создаются для организации кластера:

| Узел           | IP адрес  | Описание                                                                                                                                                                             |
|----------------|-----------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| control        | 10.0.2.15 | Управляющая ВМ, с этой машины запускаются ansible скрипты и раскатываются на остальные машины. Необходимо, чтобы с этой машины был ssh доступ до всех остальных машин |
| kube-master    | 10.0.2.5  | master-нода k8s кластера                                                                                                                                                             |
| kube-worker-01 | 10.0.2.6  | Ноды исполняющие рабочую нагрузку на кластере                                                                                                                                        |
| kube-worker-02 | 10.0.2.7  |                                                                                                                                                                                      |
| ...            | ...       | ...                                                                                                                                                                                  |

> **Важно:** необходимо заменить IP адреса на фактические адреса внутри сети

### Пререквезиты (nodes)

Перед началом установки необходимо убедиться, что выполнены следующие шаги:

- [ ] На kube-* установлена Ubuntu Server 24 с единого дистрибутива
- [ ] Необходимо обновить все экземпляры/ноды:
```bash
sudo apt update -y && sudo apt upgrade -y
```
- [ ] Убедиться, что ssh включен и работает
```bash
sudo apt install openssh-server
```
- [ ] А порт 22 открыт
```bash
ss -tulpn | grep 22
```
- [ ] На всех нодах заведен пользователь с правами администратора, от имени которого будут устанавливаться ssh соединения и производиться настройка

### Пререквезиты (Ansible host)

Установка кластера производится с помощью инструмента Ansible. Для этого необходимо выделить отдельную ноду вне кластера, на которой будет запущен Ansible.

- [ ] Установка Ansible на control node:
```bash
sudo apt install ansible -y
```
- [ ] Настройка SSH ключей для беспарольного доступа:
```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
ssh-copy-id your_privileged_user@your_master_node_ip_address
ssh-copy-id your_privileged_user@your_worker_node_ip_address
```

## 🔧 Ansible роли

Для каждого вида автоматизируемого ресурса создана отдельная роль:

### kubernetes_master
Роль для настройки master-ноды Kubernetes кластера. Включает:
- Установку и настройку containerd
- Установку компонентов Kubernetes (kubeadm, kubelet, kubectl)
- Инициализацию control plane
- Настройку сетевых параметров

### kubernetes_worker
Роль для настройки worker-нод Kubernetes кластера. Включает:
- Установку и настройку containerd
- Установку компонентов Kubernetes
- Присоединение к кластеру
- Настройку сетевых параметров

### kubernetes_network
Роль для настройки сетевого плагина Flannel. Включает:
- Установку Flannel CNI
- Настройку pod network CIDR
- Конфигурацию сетевого взаимодействия

### metallb
Роль для установки и настройки MetalLB load balancer. Включает:
- Установку MetalLB в кластере
- Настройку IP address pools
- Конфигурацию Layer 2 advertisement
- Верификацию установки

### storage
Роль для настройки Local Storage Provisioner - простого и эффективного решения для постоянного хранения данных без использования внешнего NFS. Включает:
- Local Storage Provisioner с автоматическим обнаружением томов
- Создание StorageClass для управления томами
- Настройку путей хранения на worker узлах
- Высокую производительность локального хранения

### monitoring
Роль для настройки системы мониторинга Prometheus + Grafana. Включает:
- Prometheus для сбора и хранения метрик
- Grafana для визуализации и дашбордов
- Node Exporter для метрик узлов кластера
- Настройку алертов и уведомлений

### demo_app
Роль для развертывания демо-приложения для тестирования MetalLB. Включает:
- Развертывание nginx приложения
- Создание LoadBalancer сервиса
- Верификацию работы внешнего IP

## 🎯 Что получится после развертывания

### ✅ Kubernetes кластер
- Master узел с control plane
- Worker узлы для выполнения нагрузки
- Flannel CNI для сетевого взаимодействия
- Все компоненты Kubernetes работают

### ✅ MetalLB Load Balancer
- MetalLB установлен в namespace `metallb-system`
- IP пул настроен: `10.0.2.240-10.0.2.250`
- Layer 2 advertisement настроен
- Готов к назначению внешних IP

### ✅ Local Storage
- Local Storage Provisioner установлен
- StorageClass создан для автоматического управления томами
- PersistentVolumes доступны для приложений
- Высокая производительность локального хранения

### ✅ Monitoring
- Prometheus установлен для сбора метрик
- Grafana установлен для визуализации
- Node Exporter собирает метрики узлов
- Система готова к настройке алертов

### ✅ Демо-приложение
- Nginx развернут с 3 репликами
- LoadBalancer сервис создан
- Внешний IP назначен автоматически
- Приложение доступно извне кластера

## 🔧 Полезные команды

### Проверка кластера
```bash
# Проверка узлов
kubectl get nodes

# Проверка всех подов
kubectl get pods --all-namespaces

# Проверка сервисов
kubectl get services --all-namespaces
```

### Создание LoadBalancer сервиса
```bash
# Создание deployment
kubectl create deployment my-app --image=nginx

# Создание LoadBalancer сервиса
kubectl expose deployment my-app --port=80 --type=LoadBalancer

# Проверка внешнего IP
kubectl get service my-app
```

### Автоматическое тестирование
```bash
# Переход в директорию ansible
cd ansible

# Проверка готовности виртуальных машин
./scripts/validate-vm-setup.sh

# Запуск автоматического теста MetalLB
./scripts/test-metallb.sh

# Запуск автоматического теста Local Storage
./scripts/test-local-storage.sh

# Запуск автоматического теста Monitoring
./scripts/test-monitoring.sh
```

## 🆘 Устранение неполадок

### Проблема: Узлы не присоединяются к кластеру
```bash
# Проверка join команды на master
kubeadm token create --print-join-command

# Проверка логов kubelet на worker
sudo journalctl -u kubelet -f
```

### Проблема: MetalLB не назначает IP
```bash
# Проверка логов MetalLB
kubectl logs -n metallb-system -l app=metallb -c controller
kubectl logs -n metallb-system -l app=metallb -c speaker
```

### Проблема: Проблемы с сетью
```bash
# Проверка подов Flannel
kubectl get pods -n kube-flannel

# Тест сетевого соединения
ping 10.0.2.5  # с worker на master
```

## 🎓 Обучение

Этот проект предназначен не только для развертывания кластера, но и для изучения Kubernetes. Используйте учебные материалы в директории `docs/learning/` для:

- Изучения теории Kubernetes
- Выполнения практических упражнений
- Проверки своих знаний с помощью тестов
- Отслеживания прогресса обучения

## 📚 Документация

### 🎯 Быстрые старты
- **[QUICK_START.md](docs/getting-started/QUICK_START.md)** - Быстрое развертывание кластера
- **[VM_QUICK_START.md](docs/getting-started/VM_QUICK_START.md)** - Быстрое создание виртуальных машин
- **[QUICK_START_LOCAL_STORAGE.md](docs/getting-started/QUICK_START_LOCAL_STORAGE.md)** - Настройка Local Storage
- **[QUICK_START_MONITORING.md](docs/getting-started/QUICK_START_MONITORING.md)** - Настройка мониторинга
- **[QUICK_START_NVIDIA_MONITORING.md](docs/getting-started/QUICK_START_NVIDIA_MONITORING.md)** - GPU мониторинг

### 🛠 Руководства по развертыванию
- **[DEPLOYMENT_GUIDE.md](docs/deployment/DEPLOYMENT_GUIDE.md)** - Подробное руководство по развертыванию
- **[VM_SETUP_CHECKLIST.md](docs/deployment/VM_SETUP_CHECKLIST.md)** - Чек-лист настройки виртуальных машин
- **[VIRTUALBOX_SETUP_GUIDE.md](docs/deployment/VIRTUALBOX_SETUP_GUIDE.md)** - Полное руководство по VirtualBox

### 🔧 Компоненты
- **[MetalLB](docs/components/metallb/)** - Load Balancer для bare metal
- **[Local Storage](docs/components/storage/)** - Локальное хранилище
- **[Monitoring](docs/components/monitoring/)** - Prometheus + Grafana
- **[GPU Support](docs/components/gpu/)** - Поддержка GPU узлов

### 🎓 Учебные материалы
- **[LEARNING_GUIDE.md](docs/learning/LEARNING_GUIDE.md)** - Полное учебное пособие
- **[EXERCISES.md](docs/learning/EXERCISES.md)** - Практические упражнения
- **[EXERCISES_6.1.md](docs/learning/EXERCISES_6.1.md)** - Расширенные упражнения по RBAC
- **[EXERCISES_6.2.md](docs/learning/EXERCISES_6.2.md)** - Расширенные упражнения по операторам
- **[EXERCISES_6.3.md](docs/learning/EXERCISES_6.3.md)** - Расширенные упражнения по GitOps
- **[PROGRESS_CHECKLISTS.md](docs/learning/PROGRESS_CHECKLISTS.md)** - Чек-листы для самооценки
- **[FINAL_CHECKLIST.md](docs/learning/FINAL_CHECKLIST.md)** - Финальный чек-лист
- **[QUIZ.md](docs/learning/QUIZ.md)** - Тест знаний

### 📖 Теоретические материалы
- **[K8S.md](docs/theory/K8S.md)** - Основы Kubernetes
- **[K8S_LINUX.md](docs/theory/K8S_LINUX.md)** - Kubernetes на Linux
- **[K8S_ORCHESTRATION.md](docs/theory/K8S_ORCHESTRATION.md)** - Оркестрация в Kubernetes
- **[GLOSSARY.md](docs/theory/GLOSSARY.md)** - Глоссарий терминов

### 📋 Справочные материалы
- **[RESOURCES.md](docs/reference/RESOURCES.md)** - Полезные ресурсы
- **[VERSIONING.md](docs/reference/VERSIONING.md)** - Версионирование
- **[DIAGRAMS.md](docs/reference/DIAGRAMS.md)** - Диаграммы архитектуры
- **[STUDY_GUIDE_OVERVIEW.md](docs/STUDY_GUIDE_OVERVIEW.md)** - Обзор учебного пособия

## 🎮 GPU Support

NVidia provides support for cuda playbooks: https://github.com/NVIDIA/ansible-role-nvidia-driver

### 1. Install CUDA ansible playbook
```bash
ansible-galaxy install nvidia.nvidia_driver
ansible-playbook -i playbooks/inventory.yml playbooks/site_gpu_nodes.yml -K
```

## 📞 Поддержка

Если у вас возникли вопросы или проблемы:

1. Проверьте документацию в директории `docs/`
2. Изучите раздел "Устранение неполадок" выше
3. Проверьте логи компонентов
4. Создайте issue в репозитории

## 🔗 Полезные ссылки

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [MetalLB Documentation](https://metallb.universe.tf/)
- [Ansible Documentation](https://docs.ansible.com/)
- [Prometheus Documentation](https://prometheus.io/docs/)
- [Grafana Documentation](https://grafana.com/docs/)

---

**Удачного изучения Kubernetes! 🚀**