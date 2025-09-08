# Руководство по созданию виртуальных машин для Kubernetes кластера

Это подробное руководство поможет вам создать виртуальную среду для тестирования Kubernetes кластера с Ansible на любой операционной системе (macOS, Windows, Linux) с использованием VirtualBox.

## 📋 Содержание

1. [Установка VirtualBox](#установка-virtualbox)
2. [Скачивание образов Ubuntu](#скачивание-образов-ubuntu)
3. [Создание управляющего узла (Control Node)](#создание-управляющего-узла-control-node)
4. [Создание Master узла](#создание-master-узла)
5. [Создание Worker узлов](#создание-worker-узлов)
6. [Настройка сети](#настройка-сети)
7. [Настройка SSH доступа](#настройка-ssh-доступа)
8. [Проверка готовности](#проверка-готовности)
9. [Устранение неполадок](#устранение-неполадок)

## 🎯 Архитектура кластера

```
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Control Node  │    │   Master Node   │    │  Worker Node 1  │
│  Ubuntu Desktop │    │ Ubuntu Server   │    │ Ubuntu Server   │
│    10.0.2.15    │    │    10.0.2.5     │    │    10.0.2.6     │
│     2GB RAM     │    │     4GB RAM     │    │     4GB RAM     │
│     20GB HDD    │    │     30GB HDD    │    │     30GB HDD    │
└─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │
         └───────────────────────┼───────────────────────┘
                                 │
                    ┌─────────────────┐
                    │  Worker Node 2  │
                    │ Ubuntu Server   │
                    │    10.0.2.7     │
                    │     4GB RAM     │
                    │     30GB HDD    │
                    └─────────────────┘
```

## 🔧 Системные требования

### Минимальные требования к хосту:
- **ОЗУ**: 16 ГБ (рекомендуется 32 ГБ)
- **ЦП**: 4 ядра (рекомендуется 8 ядер)
- **Свободное место**: 200 ГБ
- **ОС**: macOS 10.15+, Windows 10+, Ubuntu 20.04+

### Требования к виртуальным машинам:
- **Control Node**: 2 ГБ ОЗУ, 20 ГБ диска
- **Master Node**: 4 ГБ ОЗУ, 30 ГБ диска
- **Worker Nodes**: 4 ГБ ОЗУ, 30 ГБ диска каждая

---

## 1. Установка VirtualBox

### macOS

1. **Скачайте VirtualBox:**
   ```bash
   # Через Homebrew (рекомендуется)
   brew install --cask virtualbox
   
   # Или скачайте с официального сайта
   # https://www.virtualbox.org/wiki/Downloads
   ```

2. **Установите VirtualBox Extension Pack:**
   - Скачайте с https://www.virtualbox.org/wiki/Downloads
   - Установите через VirtualBox Manager → File → Preferences → Extensions

### Windows

1. **Скачайте VirtualBox:**
   - Перейдите на https://www.virtualbox.org/wiki/Downloads
   - Скачайте "Windows hosts"
   - Запустите установщик от имени администратора

2. **Установите VirtualBox Extension Pack:**
   - Скачайте Extension Pack с той же страницы
   - Установите через VirtualBox Manager

### Linux (Ubuntu/Debian)

```bash
# Обновление пакетов
sudo apt update

# Установка VirtualBox
sudo apt install virtualbox virtualbox-ext-pack

# Добавление пользователя в группу vboxusers
sudo usermod -aG vboxusers $USER

# Перезагрузка для применения изменений
sudo reboot
```

### Linux (CentOS/RHEL/Fedora)

```bash
# CentOS/RHEL
sudo yum install VirtualBox

# Fedora
sudo dnf install VirtualBox

# Установка Extension Pack
sudo yum install VirtualBox-Extension-Pack
```

---

## 2. Скачивание образов Ubuntu

### Ubuntu Desktop 24.10 (для Control Node)

```bash
# Создание директории для образов
mkdir -p ~/Downloads/vm-images
cd ~/Downloads/vm-images

# Скачивание Ubuntu Desktop 24.10
wget https://releases.ubuntu.com/24.10/ubuntu-24.10-desktop-amd64.iso

# Проверка целостности (опционально)
wget https://releases.ubuntu.com/24.10/SHA256SUMS
sha256sum -c SHA256SUMS 2>/dev/null | grep ubuntu-24.10-desktop-amd64.iso
```

### Ubuntu Server 24.04 LTS (для Master и Worker узлов)

```bash
# Скачивание Ubuntu Server 24.04 LTS
wget https://releases.ubuntu.com/24.04/ubuntu-24.04.1-server-amd64.iso

# Проверка целостности (опционально)
wget https://releases.ubuntu.com/24.04/SHA256SUMS
sha256sum -c SHA256SUMS 2>/dev/null | grep ubuntu-24.04.1-server-amd64.iso
```

### Альтернативные способы скачивания

**Через браузер:**
- Ubuntu Desktop: https://ubuntu.com/download/desktop
- Ubuntu Server: https://ubuntu.com/download/server

**Через BitTorrent (быстрее):**
- Ubuntu Desktop: https://ubuntu.com/download/desktop/alternative-downloads
- Ubuntu Server: https://ubuntu.com/download/server/alternative-downloads

---

## 3. Создание управляющего узла (Control Node)

### 3.1 Создание виртуальной машины

1. **Откройте VirtualBox Manager**

2. **Создайте новую виртуальную машину:**
   - Нажмите "New"
   - Имя: `control`
   - Папка: выберите подходящую директорию
   - Тип: Linux
   - Версия: Ubuntu (64-bit)
   - Нажмите "Next"

3. **Настройте память:**
   - Размер памяти: 2048 МБ (2 ГБ)
   - Нажмите "Next"

4. **Настройте жесткий диск:**
   - Выберите "Create a virtual hard disk now"
   - Нажмите "Create"
   - Тип файла: VDI (VirtualBox Disk Image)
   - Нажмите "Next"
   - Физическое хранилище: Dynamically allocated
   - Нажмите "Next"
   - Размер: 20 ГБ
   - Нажмите "Create"

### 3.2 Настройка виртуальной машины

1. **Выберите созданную ВМ и нажмите "Settings"**

2. **Настройте процессор:**
   - Перейдите в "System" → "Processor"
   - Количество процессоров: 2
   - Включите "Enable PAE/NX"
   - Нажмите "OK"

3. **Настройте сеть:**
   - Перейдите в "Network"
   - Адаптер 1: NAT
   - Адаптер 2: Host-only Adapter
   - Нажмите "OK"

4. **Настройте хранилище:**
   - Перейдите в "Storage"
   - Выберите "Empty" под Controller: IDE
   - Нажмите на иконку диска справа
   - Выберите "Choose a disk file"
   - Выберите скачанный образ Ubuntu Desktop 24.10
   - Нажмите "OK"

### 3.3 Установка Ubuntu Desktop

1. **Запустите виртуальную машину**

2. **Следуйте инструкциям установщика:**
   - Выберите язык: English
   - Выберите раскладку клавиатуры
   - Выберите "Install Ubuntu"
   - Выберите "Normal installation"
   - Выберите "Erase disk and install Ubuntu"
   - Создайте пользователя:
     - Имя: `ansible`
     - Имя компьютера: `control`
     - Пароль: `ansible123` (или любой другой)
   - Дождитесь завершения установки
   - Перезагрузите систему

### 3.4 Настройка после установки

1. **Обновите систему:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Установите необходимые пакеты:**
   ```bash
   sudo apt install -y openssh-server git curl wget vim
   ```

3. **Настройте SSH:**
   ```bash
   sudo systemctl enable ssh
   sudo systemctl start ssh
   ```

4. **Проверьте IP адрес:**
   ```bash
   ip addr show
   # Запомните IP адрес (обычно 10.0.2.15 для NAT)
   ```

---

## 4. Создание Master узла

### 4.1 Создание виртуальной машины

1. **Создайте новую виртуальную машину:**
   - Имя: `kube-master`
   - Тип: Linux, Ubuntu (64-bit)
   - Память: 4096 МБ (4 ГБ)
   - Жесткий диск: 30 ГБ (динамически выделяемый)

2. **Настройте виртуальную машину:**
   - Процессор: 2 ядра
   - Сеть: NAT + Host-only Adapter
   - Хранилище: Ubuntu Server 24.04 LTS ISO

### 4.2 Установка Ubuntu Server

1. **Запустите виртуальную машину**

2. **Следуйте инструкциям установщика:**
   - Выберите язык: English
   - Выберите раскладку клавиатуры
   - Выберите "Install Ubuntu Server"
   - Настройте сеть (оставьте по умолчанию)
   - Настройте прокси (оставьте пустым)
   - Настройте зеркало архива (оставьте по умолчанию)
   - Настройте хранилище: "Use an entire disk"
   - Создайте пользователя:
     - Имя: `ansible`
     - Имя сервера: `kube-master`
     - Пароль: `ansible123`
   - Установите OpenSSH server (выберите "Yes")
   - Не устанавливайте дополнительные пакеты
   - Дождитесь завершения установки
   - Перезагрузите систему

### 4.3 Настройка после установки

1. **Войдите в систему и обновите:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Проверьте IP адрес:**
   ```bash
   ip addr show
   # Запомните IP адрес
   ```

3. **Проверьте SSH:**
   ```bash
   sudo systemctl status ssh
   ```

---

## 5. Создание Worker узлов

### 5.1 Создание первого Worker узла

1. **Создайте новую виртуальную машину:**
   - Имя: `kube-worker-01`
   - Тип: Linux, Ubuntu (64-bit)
   - Память: 4096 МБ (4 ГБ)
   - Жесткий диск: 30 ГБ

2. **Настройте аналогично Master узлу:**
   - Процессор: 2 ядра
   - Сеть: NAT + Host-only Adapter
   - Хранилище: Ubuntu Server 24.04 LTS ISO

3. **Установите Ubuntu Server:**
   - Имя сервера: `kube-worker-01`
   - Пользователь: `ansible`
   - Пароль: `ansible123`
   - Установите OpenSSH server

### 5.2 Создание второго Worker узла

1. **Создайте новую виртуальную машину:**
   - Имя: `kube-worker-02`
   - Остальные настройки аналогично первому Worker узлу

2. **Установите Ubuntu Server:**
   - Имя сервера: `kube-worker-02`
   - Пользователь: `ansible`
   - Пароль: `ansible123`
   - Установите OpenSSH server

### 5.3 Создание дополнительных Worker узлов (опционально)

При необходимости можно создать больше Worker узлов:
- `kube-worker-03` (IP: 10.0.2.8)
- `kube-worker-04` (IP: 10.0.2.9)
- И так далее...

---

## 6. Настройка сети

### 6.1 Настройка Host-only сети

1. **В VirtualBox Manager:**
   - Перейдите в File → Preferences → Network
   - Выберите вкладку "Host-only Networks"
   - Нажмите "+" для создания новой сети
   - Настройте сеть:
     - IPv4 Address: 192.168.56.1
     - IPv4 Network Mask: 255.255.255.0
     - DHCP Server: включен
     - Server Address: 192.168.56.100
     - Server Mask: 255.255.255.0
     - Lower Address Bound: 192.168.56.101
     - Upper Address Bound: 192.168.56.200

### 6.2 Настройка сетевых адаптеров для каждой ВМ

Для каждой виртуальной машины:

1. **Откройте настройки ВМ**
2. **Перейдите в Network**
3. **Настройте Adapter 2:**
   - Включите "Enable Network Adapter"
   - Attached to: Host-only Adapter
   - Name: vboxnet0 (или созданная вами сеть)
   - Нажмите "OK"

### 6.3 Настройка статических IP адресов

На каждой виртуальной машине настройте статические IP адреса:

#### Control Node (10.0.2.15)
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  # NAT adapter
      dhcp4: true
    enp0s8:  # Host-only adapter
      dhcp4: false
      addresses:
        - 10.0.2.15/24
      gateway4: 10.0.2.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

#### Master Node (10.0.2.5)
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  # NAT adapter
      dhcp4: true
    enp0s8:  # Host-only adapter
      dhcp4: false
      addresses:
        - 10.0.2.5/24
      gateway4: 10.0.2.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

#### Worker Node 1 (10.0.2.6)
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  # NAT adapter
      dhcp4: true
    enp0s8:  # Host-only adapter
      dhcp4: false
      addresses:
        - 10.0.2.6/24
      gateway4: 10.0.2.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

#### Worker Node 2 (10.0.2.7)
```bash
sudo nano /etc/netplan/00-installer-config.yaml
```

```yaml
network:
  version: 2
  ethernets:
    enp0s3:  # NAT adapter
      dhcp4: true
    enp0s8:  # Host-only adapter
      dhcp4: false
      addresses:
        - 10.0.2.7/24
      gateway4: 10.0.2.1
      nameservers:
        addresses: [8.8.8.8, 8.8.4.4]
```

### 6.4 Применение сетевых настроек

На каждой машине выполните:
```bash
sudo netplan apply
sudo systemctl restart systemd-networkd
```

### 6.5 Проверка сетевого подключения

На Control Node проверьте подключение ко всем узлам:
```bash
ping -c 3 10.0.2.5  # master
ping -c 3 10.0.2.6  # worker-01
ping -c 3 10.0.2.7  # worker-02
```

---

## 7. Настройка SSH доступа

### 7.1 Генерация SSH ключей на Control Node

```bash
# Войдите в Control Node
ssh ansible@10.0.2.15

# Сгенерируйте SSH ключ
ssh-keygen -t rsa -b 4096 -C "ansible@control"
# Нажмите Enter для всех вопросов (используйте значения по умолчанию)
```

### 7.2 Копирование ключей на все узлы

```bash
# Копирование ключа на master узел
ssh-copy-id ansible@10.0.2.5

# Копирование ключа на worker узлы
ssh-copy-id ansible@10.0.2.6
ssh-copy-id ansible@10.0.2.7

# При запросе пароля введите: ansible123
```

### 7.3 Проверка SSH подключения

```bash
# Проверьте подключение без пароля
ssh ansible@10.0.2.5  # master
ssh ansible@10.0.2.6  # worker-01
ssh ansible@10.0.2.7  # worker-02

# Выйдите из каждого подключения командой: exit
```

### 7.4 Настройка SSH конфигурации (опционально)

Создайте файл конфигурации SSH для удобства:
```bash
nano ~/.ssh/config
```

```bash
Host master
    HostName 10.0.2.5
    User ansible
    IdentityFile ~/.ssh/id_rsa

Host worker-01
    HostName 10.0.2.6
    User ansible
    IdentityFile ~/.ssh/id_rsa

Host worker-02
    HostName 10.0.2.7
    User ansible
    IdentityFile ~/.ssh/id_rsa
```

Теперь можно подключаться просто:
```bash
ssh master
ssh worker-01
ssh worker-02
```

---

## 8. Проверка готовности

### 8.1 Установка Ansible на Control Node

```bash
# Обновите пакеты
sudo apt update

# Установите Ansible
sudo apt install ansible -y

# Проверьте версию
ansible --version
```

### 8.2 Создание inventory файла

```bash
# Создайте директорию для проекта
mkdir -p ~/kubernetes-cluster
cd ~/kubernetes-cluster

# Создайте inventory файл
nano inventory.yml
```

```yaml
all:
  children:
    master_nodes:
      hosts:
        kube-master:
          ansible_host: 10.0.2.5
          ansible_user: ansible
    worker_nodes:
      hosts:
        kube-worker-01:
          ansible_host: 10.0.2.6
          ansible_user: ansible
        kube-worker-02:
          ansible_host: 10.0.2.7
          ansible_user: ansible

all:
  vars:
    ansible_python_interpreter: "/usr/bin/python3"
```

### 8.3 Тестирование Ansible подключения

```bash
# Проверьте подключение ко всем узлам
ansible all -i inventory.yml -m ping

# Ожидаемый результат:
# kube-master | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }
# kube-worker-01 | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }
# kube-worker-02 | SUCCESS => {
#     "ansible_facts": {
#         "discovered_interpreter_python": "/usr/bin/python3"
#     },
#     "changed": false,
#     "ping": "pong"
# }
```

### 8.4 Проверка системных ресурсов

```bash
# Проверьте ресурсы всех узлов
ansible all -i inventory.yml -m setup -a "filter=ansible_memtotal_mb"
ansible all -i inventory.yml -m setup -a "filter=ansible_processor_vcpus"
```

### 8.5 Клонирование репозитория

```bash
# Клонируйте репозиторий с Ansible ролями
git clone <your-repository-url> kubernetes-with-ansible
cd kubernetes-with-ansible

# Скопируйте ваш inventory файл
cp ~/kubernetes-cluster/inventory.yml .
```

---

## 9. Устранение неполадок

### 9.1 Проблемы с сетью

**Проблема: Не удается подключиться по SSH**
```bash
# Проверьте статус SSH на целевой машине
sudo systemctl status ssh

# Проверьте, что SSH слушает на порту 22
sudo netstat -tlnp | grep :22

# Проверьте файрвол
sudo ufw status
```

**Проблема: Не удается пинговать между узлами**
```bash
# Проверьте сетевые интерфейсы
ip addr show

# Проверьте маршруты
ip route show

# Перезапустите сетевые службы
sudo systemctl restart systemd-networkd
sudo netplan apply
```

### 9.2 Проблемы с VirtualBox

**Проблема: ВМ не запускается**
- Проверьте, что включена виртуализация в BIOS
- Убедитесь, что установлен VirtualBox Extension Pack
- Проверьте, что у пользователя есть права на группу vboxusers

**Проблема: Медленная работа ВМ**
- Увеличьте количество выделенной памяти
- Включите аппаратную виртуализацию в настройках ВМ
- Установите Guest Additions

### 9.3 Проблемы с Ansible

**Проблема: Ansible не может подключиться**
```bash
# Проверьте SSH подключение вручную
ssh ansible@10.0.2.5

# Проверьте SSH ключи
ssh-add -l

# Проверьте права на SSH ключи
chmod 600 ~/.ssh/id_rsa
chmod 644 ~/.ssh/id_rsa.pub
```

**Проблема: Ошибки Python**
```bash
# Установите Python на целевых узлах
ansible all -i inventory.yml -m raw -a "sudo apt install python3 -y"
```

### 9.4 Полезные команды для диагностики

```bash
# Проверка статуса всех ВМ
VBoxManage list runningvms

# Проверка сетевых настроек ВМ
VBoxManage showvminfo kube-master --machinereadable | grep -i network

# Проверка использования ресурсов
VBoxManage metrics query kube-master

# Создание снимка состояния ВМ
VBoxManage snapshot kube-master take "before-k8s-install"

# Восстановление из снимка
VBoxManage snapshot kube-master restore "before-k8s-install"
```

---

## 10. Следующие шаги

После успешного создания виртуальных машин вы можете:

1. **Запустить развертывание Kubernetes кластера:**
   ```bash
   ansible-playbook -i inventory.yml site.yml
   ```

2. **Проверить результаты:**
   ```bash
   ssh ansible@10.0.2.5
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

3. **Изучить дополнительные материалы:**
   - [QUICK_START.md](QUICK_START.md) - Быстрый старт
   - [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md) - Подробное руководство
   - [LEARNING_GUIDE.md](LEARNING_GUIDE.md) - Учебное пособие

---

## 📚 Дополнительные ресурсы

- [Документация VirtualBox](https://www.virtualbox.org/manual/)
- [Документация Ubuntu Server](https://ubuntu.com/server/docs)
- [Документация Ansible](https://docs.ansible.com/)
- [Документация Kubernetes](https://kubernetes.io/docs/)

---

## 🆘 Поддержка

Если у вас возникли проблемы:

1. Проверьте раздел "Устранение неполадок"
2. Изучите логи VirtualBox и виртуальных машин
3. Проверьте системные требования
4. Обратитесь к документации соответствующих компонентов

**Удачного тестирования Kubernetes кластера! 🚀**
