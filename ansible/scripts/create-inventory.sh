#!/bin/bash

# Скрипт для создания inventory файла для Kubernetes кластера
# Использование: ./create-inventory.sh

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

# Функция для ввода с проверкой
read_input() {
    local prompt=$1
    local default=$2
    local value
    
    if [ -n "$default" ]; then
        read -p "$prompt [$default]: " value
        value=${value:-$default}
    else
        read -p "$prompt: " value
    fi
    
    echo "$value"
}

# Функция для проверки IP адреса
validate_ip() {
    local ip=$1
    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        local IFS='.'
        local -a ip_parts=($ip)
        for part in "${ip_parts[@]}"; do
            if [ "$part" -gt 255 ]; then
                return 1
            fi
        done
        return 0
    else
        return 1
    fi
}

# Функция для проверки подключения к хосту
test_connection() {
    local ip=$1
    local user=$2
    
    print_status "INFO" "Проверка подключения к $ip..."
    
    if ping -c 1 -W 5 "$ip" &> /dev/null; then
        print_status "SUCCESS" "Хост $ip доступен по сети"
        
        if ssh -o ConnectTimeout=10 -o BatchMode=yes "$user@$ip" "echo 'SSH connection successful'" &> /dev/null; then
            print_status "SUCCESS" "SSH подключение к $ip работает"
            return 0
        else
            print_status "WARNING" "SSH подключение к $ip не работает (проверьте SSH ключи)"
            return 1
        fi
    else
        print_status "ERROR" "Хост $ip недоступен по сети"
        return 1
    fi
}

# Основная функция
main() {
    local inventory_file="playbooks/inventory.yml"
    local master_ip=""
    local master_user="ansible"
    local worker_ips=()
    local worker_user="ansible"
    local add_more_workers=true
    
    print_status "INFO" "Создание inventory файла для Kubernetes кластера"
    echo
    
    # Проверяем, существует ли уже inventory файл
    if [ -f "$inventory_file" ]; then
        print_status "WARNING" "Файл $inventory_file уже существует"
        read -p "Перезаписать? (y/N): " overwrite
        if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
            print_status "INFO" "Создание отменено"
            exit 0
        fi
    fi
    
    # Получаем информацию о master узле
    print_status "INFO" "Настройка Master узла"
    echo
    
    while true; do
        master_ip=$(read_input "IP адрес Master узла" "10.0.2.5")
        if validate_ip "$master_ip"; then
            break
        else
            print_status "ERROR" "Неверный формат IP адреса"
        fi
    done
    
    master_user=$(read_input "Пользователь для Master узла" "ansible")
    
    # Тестируем подключение к master узлу
    if test_connection "$master_ip" "$master_user"; then
        print_status "SUCCESS" "Master узел настроен: $master_user@$master_ip"
    else
        print_status "WARNING" "Не удалось подключиться к Master узлу, но продолжаем создание inventory"
    fi
    echo
    
    # Получаем информацию о worker узлах
    print_status "INFO" "Настройка Worker узлов"
    echo
    
    worker_user=$(read_input "Пользователь для Worker узлов" "ansible")
    
    local worker_count=1
    while [ "$add_more_workers" = true ]; do
        local worker_ip=""
        
        while true; do
            worker_ip=$(read_input "IP адрес Worker узла $worker_count" "10.0.2.$((5 + worker_count))")
            if validate_ip "$worker_ip"; then
                break
            else
                print_status "ERROR" "Неверный формат IP адреса"
            fi
        done
        
        # Тестируем подключение к worker узлу
        if test_connection "$worker_ip" "$worker_user"; then
            print_status "SUCCESS" "Worker узел $worker_count настроен: $worker_user@$worker_ip"
        else
            print_status "WARNING" "Не удалось подключиться к Worker узлу $worker_count, но добавляем в inventory"
        fi
        
        worker_ips+=("$worker_ip")
        ((worker_count++))
        
        echo
        read -p "Добавить еще один Worker узел? (y/N): " add_more
        if [[ ! "$add_more" =~ ^[Yy]$ ]]; then
            add_more_workers=false
        fi
    done
    
    # Создаем inventory файл
    print_status "INFO" "Создание inventory файла: $inventory_file"
    
    cat > "$inventory_file" << EOF
---
master_nodes:
  hosts:
    kube-master:
      ansible_host: $master_ip
      ansible_user: $master_user

worker_nodes:
  hosts:
EOF
    
    # Добавляем worker узлы
    for i in "${!worker_ips[@]}"; do
        local worker_num=$((i + 1))
        cat >> "$inventory_file" << EOF
    kube-worker-$(printf "%02d" $worker_num):
      ansible_host: ${worker_ips[$i]}
      ansible_user: $worker_user
EOF
    done
    
    # Добавляем общие переменные
    cat >> "$inventory_file" << EOF

all:
  vars:
    ansible_python_interpreter: "/usr/bin/python3"
    ansible_user: "$worker_user"
EOF
    
    print_status "SUCCESS" "Inventory файл создан: $inventory_file"
    echo
    
    # Показываем содержимое созданного файла
    print_status "INFO" "Содержимое созданного inventory файла:"
    echo
    cat "$inventory_file"
    echo
    
    # Предлагаем протестировать подключение
    print_status "INFO" "Хотите протестировать подключение ко всем узлам?"
    read -p "Запустить тест? (Y/n): " run_test
    
    if [[ ! "$run_test" =~ ^[Nn]$ ]]; then
        echo
        print_status "INFO" "Запуск теста подключения..."
        
        if command -v ansible &> /dev/null; then
            if ansible all -i "$inventory_file" -m ping; then
                print_status "SUCCESS" "Все узлы доступны через Ansible!"
            else
                print_status "WARNING" "Некоторые узлы недоступны через Ansible"
            fi
        else
            print_status "WARNING" "Ansible не установлен, пропускаем тест"
        fi
    fi
    
    echo
    print_status "SUCCESS" "Inventory файл готов к использованию!"
    print_status "INFO" "Следующие шаги:"
    print_status "INFO" "1. Проверьте настройки: ./scripts/validate-vm-setup.sh $inventory_file"
    print_status "INFO" "2. Запустите развертывание: ansible-playbook -i $inventory_file playbooks/site.yml"
}

# Запускаем основную функцию
main "$@"
