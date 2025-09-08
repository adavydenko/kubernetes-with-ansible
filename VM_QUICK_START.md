# Быстрый старт: Создание виртуальных машин для Kubernetes

## 🚀 За 30 минут до готового кластера

Это краткое руководство поможет вам быстро создать виртуальные машины и развернуть Kubernetes кластер.

## 📋 Что нужно

- **VirtualBox** (любая версия 6.0+)
- **16 ГБ ОЗУ** на хосте (минимум)
- **200 ГБ свободного места**
- **Ubuntu образы** (скачаются автоматически)

## ⚡ Быстрый старт

### 1. Установка VirtualBox (5 минут)

**macOS:**
```bash
brew install --cask virtualbox
```

**Windows:**
- Скачайте с https://www.virtualbox.org/wiki/Downloads
- Установите "Windows hosts"

**Linux:**
```bash
sudo apt install virtualbox virtualbox-ext-pack
```

### 2. Создание виртуальных машин (15 минут)

#### Control Node (управляющий узел)
- **Имя:** `control`
- **ОС:** Ubuntu Desktop 24.10
- **ОЗУ:** 2 ГБ
- **Диск:** 20 ГБ
- **IP:** 10.0.2.15

#### Master Node (главный узел)
- **Имя:** `kube-master`
- **ОС:** Ubuntu Server 24.04 LTS
- **ОЗУ:** 4 ГБ
- **Диск:** 30 ГБ
- **IP:** 10.0.2.5

#### Worker Nodes (рабочие узлы)
- **Имена:** `kube-worker-01`, `kube-worker-02`
- **ОС:** Ubuntu Server 24.04 LTS
- **ОЗУ:** 4 ГБ каждый
- **Диск:** 30 ГБ каждый
- **IP:** 10.0.2.6, 10.0.2.7

### 3. Настройка сети (5 минут)

На каждой ВМ:
1. **Адаптер 1:** NAT (для интернета)
2. **Адаптер 2:** Host-only Adapter (для кластера)

### 4. Установка ОС (5 минут)

**Для всех узлов:**
- Пользователь: `ansible`
- Пароль: `ansible123`
- Установить OpenSSH server

## 🔧 Автоматизация

### Создание inventory файла
```bash
./scripts/create-inventory.sh
```

### Проверка готовности
```bash
./scripts/validate-vm-setup.sh
```

### Развертывание кластера
```bash
ansible-playbook -i inventory.yml site.yml
```

## ✅ Проверка результатов

```bash
# Подключение к master узлу
ssh ansible@10.0.2.5

# Проверка кластера
kubectl get nodes
kubectl get pods --all-namespaces

# Проверка MetalLB
kubectl get service -n demo
curl http://10.0.2.240
```

## 🆘 Если что-то пошло не так

1. **Проверьте сеть:** `ping 10.0.2.5`
2. **Проверьте SSH:** `ssh ansible@10.0.2.5`
3. **Запустите валидацию:** `./scripts/validate-vm-setup.sh`

## 📚 Подробная документация

- [Полное руководство по VirtualBox](VIRTUALBOX_SETUP_GUIDE.md)
- [Быстрый старт Kubernetes](QUICK_START.md)
- [Руководство по развертыванию](DEPLOYMENT_GUIDE.md)

---

**Готово! Ваш Kubernetes кластер работает! 🎉**
