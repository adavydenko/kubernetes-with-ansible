#!/bin/bash

# Kubernetes и Linux Validation Scripts
# Набор скриптов для проверки настроек и диагностики проблем

set -euo pipefail

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функции логирования
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Проверка зависимостей
check_dependencies() {
    log_info "Проверка зависимостей..."
    
    local deps=("kubectl" "jq" "curl" "nvidia-smi")
    local missing_deps=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing_deps+=("$dep")
        fi
    done
    
    if [ ${#missing_deps[@]} -ne 0 ]; then
        log_error "Отсутствуют зависимости: ${missing_deps[*]}"
        return 1
    fi
    
    log_success "Все зависимости установлены"
}

# Проверка подключения к кластеру
check_cluster_connection() {
    log_info "Проверка подключения к кластеру..."
    
    if ! kubectl cluster-info &> /dev/null; then
        log_error "Не удается подключиться к кластеру"
        return 1
    fi
    
    local cluster_info=$(kubectl cluster-info | head -1)
    log_success "Подключение к кластеру: $cluster_info"
}

# Проверка версий компонентов
check_versions() {
    log_info "Проверка версий компонентов..."
    
    echo "=== Версии компонентов ==="
    echo "Kubernetes: $(kubectl version --client --short)"
    echo "Kubernetes Server: $(kubectl version --short 2>/dev/null | grep Server || echo 'Недоступно')"
    
    if command -v nvidia-smi &> /dev/null; then
        echo "NVIDIA Driver: $(nvidia-smi --query-gpu=driver_version --format=csv,noheader,nounits | head -1)"
    fi
    
    if command -v nvcc &> /dev/null; then
        echo "CUDA: $(nvcc --version | grep release | awk '{print $6}' | sed 's/,//')"
    fi
    
    log_success "Проверка версий завершена"
}

# Проверка узлов кластера
check_nodes() {
    log_info "Проверка узлов кластера..."
    
    echo "=== Статус узлов ==="
    kubectl get nodes -o wide
    
    echo -e "\n=== Детальная информация об узлах ==="
    kubectl get nodes -o json | jq -r '.items[] | "\(.metadata.name): \(.status.conditions[] | select(.type=="Ready") | .status)"'
    
    # Проверка узлов с GPU
    local gpu_nodes=$(kubectl get nodes -o json | jq -r '.items[] | select(.status.allocatable["nvidia.com/gpu"] != null) | .metadata.name')
    
    if [ -n "$gpu_nodes" ]; then
        echo -e "\n=== Узлы с GPU ==="
        echo "$gpu_nodes"
        
        for node in $gpu_nodes; do
            echo -e "\n--- Узел: $node ---"
            kubectl get node "$node" -o json | jq -r '.status.allocatable | "GPU: \(.["nvidia.com/gpu"] // "0")"'
        done
    else
        log_warning "Узлы с GPU не найдены"
    fi
    
    log_success "Проверка узлов завершена"
}

# Проверка подов
check_pods() {
    log_info "Проверка подов..."
    
    echo "=== Статус подов ==="
    kubectl get pods --all-namespaces
    
    # Проверка подов с ошибками
    local failed_pods=$(kubectl get pods --all-namespaces --field-selector=status.phase=Failed -o json | jq -r '.items[] | "\(.metadata.namespace)/\(.metadata.name)"')
    
    if [ -n "$failed_pods" ]; then
        log_warning "Найдены поды с ошибками:"
        echo "$failed_pods"
    fi
    
    # Проверка подов с GPU
    local gpu_pods=$(kubectl get pods --all-namespaces -o json | jq -r '.items[] | select(.spec.containers[].resources.limits["nvidia.com/gpu"] != null) | "\(.metadata.namespace)/\(.metadata.name)"')
    
    if [ -n "$gpu_pods" ]; then
        echo -e "\n=== Поды с GPU ==="
        echo "$gpu_pods"
    fi
    
    log_success "Проверка подов завершена"
}

# Проверка сервисов
check_services() {
    log_info "Проверка сервисов..."
    
    echo "=== Сервисы ==="
    kubectl get services --all-namespaces
    
    # Проверка LoadBalancer сервисов
    local lb_services=$(kubectl get services --all-namespaces -o json | jq -r '.items[] | select(.spec.type=="LoadBalancer") | "\(.metadata.namespace)/\(.metadata.name)"')
    
    if [ -n "$lb_services" ]; then
        echo -e "\n=== LoadBalancer сервисы ==="
        echo "$lb_services"
    fi
    
    log_success "Проверка сервисов завершена"
}

# Проверка GPU оборудования
check_gpu_hardware() {
    log_info "Проверка GPU оборудования..."
    
    if ! command -v nvidia-smi &> /dev/null; then
        log_warning "nvidia-smi не найден - пропускаем проверку GPU"
        return 0
    fi
    
    echo "=== Информация о GPU ==="
    nvidia-smi --query-gpu=index,name,memory.total,memory.free,utilization.gpu,temperature.gpu --format=csv
    
    echo -e "\n=== Количество GPU ==="
    nvidia-smi --list-gpus | wc -l
    
    echo -e "\n=== Проверка NVLink ==="
    if nvidia-smi nvlink --status &> /dev/null; then
        nvidia-smi nvlink --status
    else
        log_warning "NVLink недоступен или не поддерживается"
    fi
    
    echo -e "\n=== Топология GPU ==="
    nvidia-smi topo -m
    
    log_success "Проверка GPU оборудования завершена"
}

# Проверка NVIDIA Device Plugin
check_nvidia_device_plugin() {
    log_info "Проверка NVIDIA Device Plugin..."
    
    local plugin_pods=$(kubectl get pods -n kube-system -l name=nvidia-device-plugin-ds -o json | jq -r '.items[] | "\(.metadata.name)"')
    
    if [ -z "$plugin_pods" ]; then
        log_error "NVIDIA Device Plugin не найден"
        return 1
    fi
    
    echo "=== Статус NVIDIA Device Plugin ==="
    kubectl get pods -n kube-system -l name=nvidia-device-plugin-ds
    
    echo -e "\n=== Логи NVIDIA Device Plugin ==="
    for pod in $plugin_pods; do
        echo "--- Логи пода: $pod ---"
        kubectl logs -n kube-system "$pod" --tail=20
    done
    
    # Проверка доступности GPU ресурсов
    local gpu_resources=$(kubectl get nodes -o json | jq -r '.items[] | select(.status.allocatable["nvidia.com/gpu"] != null) | .status.allocatable["nvidia.com/gpu"]')
    
    if [ -n "$gpu_resources" ]; then
        echo -e "\n=== Доступные GPU ресурсы ==="
        kubectl get nodes -o json | jq -r '.items[] | select(.status.allocatable["nvidia.com/gpu"] != null) | "\(.metadata.name): \(.status.allocatable["nvidia.com/gpu"]) GPU"'
    fi
    
    log_success "Проверка NVIDIA Device Plugin завершена"
}

# Проверка мониторинга
check_monitoring() {
    log_info "Проверка системы мониторинга..."
    
    # Проверка Prometheus
    if kubectl get pods -n monitoring -l app=prometheus &> /dev/null; then
        echo "=== Prometheus ==="
        kubectl get pods -n monitoring -l app=prometheus
    else
        log_warning "Prometheus не найден в namespace monitoring"
    fi
    
    # Проверка Grafana
    if kubectl get pods -n monitoring -l app=grafana &> /dev/null; then
        echo -e "\n=== Grafana ==="
        kubectl get pods -n monitoring -l app=grafana
    else
        log_warning "Grafana не найден в namespace monitoring"
    fi
    
    # Проверка GPU экспортера
    if kubectl get pods -n monitoring -l app=nvidia-dcgm-exporter &> /dev/null; then
        echo -e "\n=== NVIDIA DCGM Exporter ==="
        kubectl get pods -n monitoring -l app=nvidia-dcgm-exporter
    else
        log_warning "NVIDIA DCGM Exporter не найден"
    fi
    
    log_success "Проверка мониторинга завершена"
}

# Проверка сетевых политик
check_network_policies() {
    log_info "Проверка сетевых политик..."
    
    echo "=== Сетевые политики ==="
    kubectl get networkpolicies --all-namespaces
    
    # Проверка CNI
    echo -e "\n=== CNI плагины ==="
    kubectl get pods -n kube-system -l k8s-app=flannel 2>/dev/null || echo "Flannel не найден"
    kubectl get pods -n kube-system -l k8s-app=calico-node 2>/dev/null || echo "Calico не найден"
    
    log_success "Проверка сетевых политик завершена"
}

# Проверка хранилища
check_storage() {
    log_info "Проверка хранилища..."
    
    echo "=== Persistent Volumes ==="
    kubectl get pv
    
    echo -e "\n=== Persistent Volume Claims ==="
    kubectl get pvc --all-namespaces
    
    echo -e "\n=== Storage Classes ==="
    kubectl get storageclass
    
    log_success "Проверка хранилища завершена"
}

# Проверка безопасности
check_security() {
    log_info "Проверка безопасности..."
    
    echo "=== Pod Security Policies ==="
    kubectl get psp 2>/dev/null || log_warning "Pod Security Policies не найдены"
    
    echo -e "\n=== RBAC ==="
    kubectl get clusterroles | head -10
    echo "..."
    
    echo -e "\n=== Service Accounts ==="
    kubectl get serviceaccounts --all-namespaces | head -10
    echo "..."
    
    log_success "Проверка безопасности завершена"
}

# Проверка производительности
check_performance() {
    log_info "Проверка производительности..."
    
    echo "=== Использование ресурсов узлов ==="
    kubectl top nodes 2>/dev/null || log_warning "Metrics Server недоступен"
    
    echo -e "\n=== Использование ресурсов подов ==="
    kubectl top pods --all-namespaces 2>/dev/null || log_warning "Metrics Server недоступен"
    
    # Проверка GPU метрик
    if command -v nvidia-smi &> /dev/null; then
        echo -e "\n=== GPU метрики ==="
        nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu --format=csv
    fi
    
    log_success "Проверка производительности завершена"
}

# Проверка APT pinning
check_apt_pinning() {
    log_info "Проверка APT pinning..."
    
    if [ ! -f /etc/apt/preferences.d/nvidia-pin-600 ]; then
        log_warning "Файл APT pinning для NVIDIA не найден"
        return 0
    fi
    
    echo "=== APT pinning конфигурация ==="
    cat /etc/apt/preferences.d/nvidia-pin-600
    
    echo -e "\n=== Проверка политики пакетов ==="
    apt policy nvidia-driver-535 2>/dev/null || log_warning "Не удается проверить политику пакетов"
    
    log_success "Проверка APT pinning завершена"
}

# Проверка системных ресурсов
check_system_resources() {
    log_info "Проверка системных ресурсов..."
    
    echo "=== Использование CPU ==="
    top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1
    
    echo -e "\n=== Использование памяти ==="
    free -h
    
    echo -e "\n=== Использование диска ==="
    df -h
    
    echo -e "\n=== Загрузка системы ==="
    uptime
    
    log_success "Проверка системных ресурсов завершена"
}

# Проверка сетевого подключения
check_network_connectivity() {
    log_info "Проверка сетевого подключения..."
    
    echo "=== Проверка DNS ==="
    nslookup kubernetes.default.svc.cluster.local 2>/dev/null || log_warning "DNS недоступен"
    
    echo -e "\n=== Проверка API сервера ==="
    kubectl get --raw /healthz 2>/dev/null || log_error "API сервер недоступен"
    
    echo -e "\n=== Проверка внешнего подключения ==="
    curl -s --connect-timeout 5 https://www.google.com >/dev/null && log_success "Внешнее подключение работает" || log_warning "Внешнее подключение недоступно"
    
    log_success "Проверка сетевого подключения завершена"
}

# Генерация отчета
generate_report() {
    local report_file="kubernetes_validation_report_$(date +%Y%m%d_%H%M%S).txt"
    
    log_info "Генерация отчета: $report_file"
    
    {
        echo "=== Отчет проверки Kubernetes кластера ==="
        echo "Дата: $(date)"
        echo "Пользователь: $(whoami)"
        echo "Хост: $(hostname)"
        echo ""
        
        echo "=== Версии компонентов ==="
        kubectl version --client --short 2>/dev/null || echo "kubectl недоступен"
        echo ""
        
        echo "=== Статус узлов ==="
        kubectl get nodes -o wide 2>/dev/null || echo "Не удается получить информацию об узлах"
        echo ""
        
        echo "=== Статус подов ==="
        kubectl get pods --all-namespaces 2>/dev/null || echo "Не удается получить информацию о подах"
        echo ""
        
        echo "=== GPU информация ==="
        if command -v nvidia-smi &> /dev/null; then
            nvidia-smi --query-gpu=index,name,memory.total,utilization.gpu --format=csv 2>/dev/null || echo "Не удается получить информацию о GPU"
        else
            echo "nvidia-smi недоступен"
        fi
        echo ""
        
        echo "=== Системные ресурсы ==="
        free -h 2>/dev/null || echo "Не удается получить информацию о памяти"
        df -h 2>/dev/null || echo "Не удается получить информацию о диске"
        echo ""
        
    } > "$report_file"
    
    log_success "Отчет сохранен в файл: $report_file"
}

# Основная функция
main() {
    echo "=== Kubernetes и Linux Validation Scripts ==="
    echo "Версия: 2.1.0"
    echo "Дата: $(date)"
    echo ""
    
    # Проверка зависимостей
    check_dependencies || exit 1
    
    # Проверка подключения к кластеру
    check_cluster_connection || exit 1
    
    # Выполнение всех проверок
    check_versions
    check_nodes
    check_pods
    check_services
    check_gpu_hardware
    check_nvidia_device_plugin
    check_monitoring
    check_network_policies
    check_storage
    check_security
    check_performance
    check_apt_pinning
    check_system_resources
    check_network_connectivity
    
    # Генерация отчета
    generate_report
    
    echo ""
    log_success "Все проверки завершены успешно!"
}

# Обработка аргументов командной строки
case "${1:-all}" in
    "dependencies")
        check_dependencies
        ;;
    "cluster")
        check_cluster_connection
        ;;
    "versions")
        check_versions
        ;;
    "nodes")
        check_nodes
        ;;
    "pods")
        check_pods
        ;;
    "services")
        check_services
        ;;
    "gpu")
        check_gpu_hardware
        check_nvidia_device_plugin
        ;;
    "monitoring")
        check_monitoring
        ;;
    "network")
        check_network_policies
        check_network_connectivity
        ;;
    "storage")
        check_storage
        ;;
    "security")
        check_security
        ;;
    "performance")
        check_performance
        ;;
    "system")
        check_system_resources
        check_apt_pinning
        ;;
    "report")
        generate_report
        ;;
    "all"|*)
        main
        ;;
esac
