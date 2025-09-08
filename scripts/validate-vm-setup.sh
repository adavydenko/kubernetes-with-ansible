#!/bin/bash

# Скрипт для проверки готовности виртуальных машин к развертыванию Kubernetes кластера
# Использование: ./validate-vm-setup.sh [inventory-file]

set -e

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для вывода сообщений
print_status() {
    local status=$1
    local message=$2
    case $status in
        "INFO")
            echo -e "${BLUE}[INFO]${NC} $message"
            ;;
        "SUCCESS")
            echo -e "${GREEN}[SUCCESS]${NC} $message"
            ;;
        "WARNING")
            echo -e "${YELLOW}[WARNING]${NC} $message"
            ;;
        "ERROR")
            echo -e "${RED}[ERROR]${NC} $message"
            ;;
    esac
}

# Функция для проверки команды
check_command() {
    local cmd=$1
    local description=$2
    
    if command -v "$cmd" &> /dev/null; then
        print_status "SUCCESS" "$description: $cmd найден"
        return 0
    else
        print_status "ERROR" "$description: $cmd не найден"
        return 1
    fi
}

# Функция для проверки файла
check_file() {
    local file=$1
    local description=$2
    
    if [ -f "$file" ]; then
        print_status "SUCCESS" "$description: $file существует"
        return 0
    else
        print_status "ERROR" "$description: $file не найден"
        return 1
    fi
}

# Функция для проверки подключения к хосту
check_host_connection() {
    local host=$1
    local user=$2
    
    print_status "INFO" "Проверка подключения к $host..."
    
    if ssh -o ConnectTimeout=10 -o BatchMode=yes "$user@$host" "echo 'SSH connection successful'" &> /dev/null; then
        print_status "SUCCESS" "SSH подключение к $host работает"
        return 0
    else
        print_status "ERROR" "SSH подключение к $host не работает"
        return 1
    fi
}

# Функция для проверки системных ресурсов хоста
check_host_resources() {
    local host=$1
    local user=$2
    
    print_status "INFO" "Проверка ресурсов $host..."
    
    # Получаем информацию о системе
    local mem_info=$(ssh "$user@$host" "free -m | grep '^Mem:' | awk '{print \$2}'" 2>/dev/null || echo "0")
    local cpu_info=$(ssh "$user@$host" "nproc" 2>/dev/null || echo "0")
    local disk_info=$(ssh "$user@$host" "df -h / | tail -1 | awk '{print \$4}'" 2>/dev/null || echo "0")
    
    # Проверяем память (минимум 2GB)
    if [ "$mem_info" -ge 2048 ]; then
        print_status "SUCCESS" "$host: Память ${mem_info}MB (требуется минимум 2GB)"
    else
        print_status "WARNING" "$host: Память ${mem_info}MB (рекомендуется минимум 2GB)"
    fi
    
    # Проверяем CPU (минимум 2 ядра)
    if [ "$cpu_info" -ge 2 ]; then
        print_status "SUCCESS" "$host: CPU ядер $cpu_info (требуется минимум 2)"
    else
        print_status "WARNING" "$host: CPU ядер $cpu_info (рекомендуется минимум 2)"
    fi
    
    # Проверяем диск
    print_status "INFO" "$host: Свободное место на диске $disk_info"
}

# Функция для проверки сетевого подключения
check_network_connectivity() {
    local host=$1
    local user=$2
    
    print_status "INFO" "Проверка сетевого подключения $host..."
    
    # Проверяем пинг
    if ping -c 3 -W 5 "$host" &> /dev/null; then
        print_status "SUCCESS" "$host: Сетевой пинг работает"
    else
        print_status "ERROR" "$host: Сетевой пинг не работает"
        return 1
    fi
    
    # Проверяем SSH порт
    if nc -z -w5 "$host" 22 &> /dev/null; then
        print_status "SUCCESS" "$host: SSH порт 22 доступен"
    else
        print_status "ERROR" "$host: SSH порт 22 недоступен"
        return 1
    fi
}

# Функция для проверки Python на хосте
check_python() {
    local host=$1
    local user=$2
    
    print_status "INFO" "Проверка Python на $host..."
    
    if ssh "$user@$host" "python3 --version" &> /dev/null; then
        local python_version=$(ssh "$user@$host" "python3 --version" 2>/dev/null)
        print_status "SUCCESS" "$host: $python_version установлен"
    else
        print_status "WARNING" "$host: Python3 не найден, будет установлен автоматически"
    fi
}

# Функция для проверки Docker/containerd
check_container_runtime() {
    local host=$1
    local user=$2
    
    print_status "INFO" "Проверка контейнерного рантайма на $host..."
    
    if ssh "$user@$host" "which containerd" &> /dev/null; then
        print_status "SUCCESS" "$host: containerd уже установлен"
    elif ssh "$user@$host" "which docker" &> /dev/null; then
        print_status "WARNING" "$host: Docker найден, будет заменен на containerd"
    else
        print_status "INFO" "$host: Контейнерный рантайм не найден, будет установлен containerd"
    fi
}

# Функция для проверки Kubernetes компонентов
check_kubernetes_components() {
    local host=$1
    local user=$2
    
    print_status "INFO" "Проверка Kubernetes компонентов на $host..."
    
    local components=("kubeadm" "kubelet" "kubectl")
    local installed_components=()
    
    for component in "${components[@]}"; do
        if ssh "$user@$host" "which $component" &> /dev/null; then
            installed_components+=("$component")
        fi
    done
    
    if [ ${#installed_components[@]} -eq 0 ]; then
        print_status "INFO" "$host: Kubernetes компоненты не установлены, будут установлены автоматически"
    else
        print_status "WARNING" "$host: Найдены установленные компоненты: ${installed_components[*]}"
    fi
}

# Основная функция проверки
main() {
    local inventory_file=${1:-"inventory.yml"}
    local errors=0
    local warnings=0
    
    print_status "INFO" "Начинаем проверку готовности виртуальных машин..."
    print_status "INFO" "Используется inventory файл: $inventory_file"
    echo
    
    # Проверяем наличие необходимых команд на локальной машине
    print_status "INFO" "Проверка локальных зависимостей..."
    check_command "ansible" "Ansible" || ((errors++))
    check_command "ssh" "SSH клиент" || ((errors++))
    check_command "ping" "Ping утилита" || ((errors++))
    check_command "nc" "Netcat утилита" || ((errors++))
    echo
    
    # Проверяем наличие inventory файла
    if ! check_file "$inventory_file" "Inventory файл"; then
        print_status "ERROR" "Не найден inventory файл: $inventory_file"
        print_status "INFO" "Создайте inventory файл или укажите путь к существующему"
        exit 1
    fi
    echo
    
    # Проверяем синтаксис inventory файла
    print_status "INFO" "Проверка синтаксиса inventory файла..."
    if ansible-inventory -i "$inventory_file" --list &> /dev/null; then
        print_status "SUCCESS" "Inventory файл имеет корректный синтаксис"
    else
        print_status "ERROR" "Inventory файл содержит ошибки синтаксиса"
        ((errors++))
    fi
    echo
    
    # Получаем список хостов из inventory
    print_status "INFO" "Получение списка хостов из inventory..."
    local hosts=$(ansible all -i "$inventory_file" --list-hosts 2>/dev/null | grep -v "hosts (" | grep -v ":" | tr -d ' ')
    
    if [ -z "$hosts" ]; then
        print_status "ERROR" "Не удалось получить список хостов из inventory"
        exit 1
    fi
    
    print_status "SUCCESS" "Найдены хосты: $hosts"
    echo
    
    # Проверяем каждый хост
    for host in $hosts; do
        print_status "INFO" "Проверка хоста: $host"
        
        # Получаем IP адрес и пользователя из inventory
        local host_ip=$(ansible-inventory -i "$inventory_file" --host "$host" 2>/dev/null | grep -o '"ansible_host": "[^"]*"' | cut -d'"' -f4)
        local host_user=$(ansible-inventory -i "$inventory_file" --host "$host" 2>/dev/null | grep -o '"ansible_user": "[^"]*"' | cut -d'"' -f4)
        
        if [ -z "$host_ip" ]; then
            print_status "ERROR" "Не удалось получить IP адрес для хоста $host"
            ((errors++))
            continue
        fi
        
        if [ -z "$host_user" ]; then
            host_user="ansible"  # Значение по умолчанию
        fi
        
        print_status "INFO" "IP: $host_ip, Пользователь: $host_user"
        
        # Проверяем сетевое подключение
        if ! check_network_connectivity "$host_ip" "$host_user"; then
            ((errors++))
            continue
        fi
        
        # Проверяем SSH подключение
        if ! check_host_connection "$host_ip" "$host_user"; then
            ((errors++))
            continue
        fi
        
        # Проверяем системные ресурсы
        check_host_resources "$host_ip" "$host_user"
        
        # Проверяем Python
        check_python "$host_ip" "$host_user"
        
        # Проверяем контейнерный рантайм
        check_container_runtime "$host_ip" "$host_user"
        
        # Проверяем Kubernetes компоненты
        check_kubernetes_components "$host_ip" "$host_user"
        
        echo
    done
    
    # Проверяем Ansible подключение ко всем хостам
    print_status "INFO" "Проверка Ansible подключения ко всем хостам..."
    if ansible all -i "$inventory_file" -m ping &> /dev/null; then
        print_status "SUCCESS" "Ansible может подключиться ко всем хостам"
    else
        print_status "ERROR" "Ansible не может подключиться к некоторым хостам"
        ((errors++))
    fi
    echo
    
    # Итоговый отчет
    print_status "INFO" "Проверка завершена"
    echo
    
    if [ $errors -eq 0 ]; then
        print_status "SUCCESS" "Все проверки пройдены успешно! Виртуальные машины готовы к развертыванию Kubernetes кластера."
        echo
        print_status "INFO" "Следующие шаги:"
        print_status "INFO" "1. Запустите развертывание: ansible-playbook -i $inventory_file site.yml"
        print_status "INFO" "2. Проверьте результаты: ssh $host_user@<master-ip> && kubectl get nodes"
        exit 0
    else
        print_status "ERROR" "Обнаружены ошибки ($errors). Исправьте их перед развертыванием кластера."
        echo
        print_status "INFO" "Рекомендации:"
        print_status "INFO" "1. Проверьте сетевые настройки виртуальных машин"
        print_status "INFO" "2. Убедитесь, что SSH ключи скопированы на все хосты"
        print_status "INFO" "3. Проверьте, что все виртуальные машины запущены"
        print_status "INFO" "4. Убедитесь, что inventory файл содержит корректные IP адреса"
        exit 1
    fi
}

# Проверяем аргументы
if [ $# -gt 1 ]; then
    echo "Использование: $0 [inventory-file]"
    echo "Пример: $0 inventory.yml"
    exit 1
fi

# Запускаем основную функцию
main "$@"
