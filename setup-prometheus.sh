#!/bin/bash

# Define Prometheus Helm repository URL
prometheus_repo="https://prometheus-community.github.io/helm-charts"

# Function to check if namespace exists
check_namespace() {
    local namespace="$1"
    if kubectl get namespace "$namespace" &> /dev/null; then
        return 0
    else
        return 1
    fi
}

# Function to create namespace
create_namespace() {
    local namespace="$1"
    echo "Creating namespace $namespace..."
    kubectl create namespace "$namespace"
}

# Function to install Prometheus if not already installed
install_prometheus() {
    local namespace="monitoring"
    if check_namespace "$namespace"; then
        if helm list -n "$namespace" | grep -q "prometheus"; then
            echo "Prometheus is already installed in namespace $namespace. You can upgrade."
        else
            echo "Installing Prometheus in namespace $namespace..."
            helm install prometheus prometheus-community/kube-prometheus-stack -n "$namespace" -f config/grafana.yml -f config/prometheus.yml -f config/alert-manager.yml
            echo "Prometheus installed successfully."
        fi
    else
        create_namespace "$namespace"
        echo "Namespace $namespace created."
        kubectl apply -f grafana-secret.yml
        echo "Secret for grafana configured."
        install_prometheus
    fi
}

# Function to upgrade Prometheus
upgrade_prometheus() {
    local namespace="monitoring"
    kubectl apply -f grafana-secret.yml
    echo "Secret for grafana configured."
    echo "Upgrading Prometheus in namespace $namespace..."
    helm upgrade prometheus prometheus-community/kube-prometheus-stack -n "$namespace" -f config/grafana.yml -f config/prometheus.yml -f config/alert-manager.yml
    echo "Prometheus upgraded successfully."
}

# Function to uninstall Prometheus
uninstall_prometheus() {
    local namespace="monitoring"
    echo "Are you sure you want to uninstall Prometheus from namespace $namespace? (yes/no)"
    read confirm
    case "$confirm" in
        yes)
            echo "Uninstalling Prometheus from namespace $namespace..."
            helm uninstall prometheus -n "$namespace"
            echo "Prometheus uninstalled successfully."
            ;;
        *)
            echo "Uninstallation cancelled."
            ;;
    esac
}

# Prompt user for action
echo "Do you want to install, upgrade, or uninstall Prometheus? (install/upgrade/uninstall)"
read action

# Perform action based on user input
case "$action" in
    install)
        # Update Helm Repositories
        echo "Updating Helm repositories..."
        helm repo update
        install_prometheus
        ;;
    upgrade)
        upgrade_prometheus
        ;;
    uninstall)
        uninstall_prometheus
        ;;
    *)
        echo "Invalid action. Please choose 'install', 'upgrade', or 'uninstall'."
        ;;
esac
