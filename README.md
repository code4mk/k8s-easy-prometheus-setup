# 🚀 Setup Prometheus (kube-prometheus-stack) on Kubernetes

Easily set up Prometheus (kube-prometheus-stack) on Kubernetes and configure Prometheus, Grafana, and Alertmanager.

# 🔧 Manual Process

## 📥 Add Helm Repo 

```bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
```

## 🏷️ Create Namespace
```bash
kubectl create namespace monitoring
```

## 🔑 Add Grafana Secrets (Alert Credentials: Email, Slack, etc.)
```bash
kubectl apply -f grafana-secret.yml
```

### 🔐 Base64 Generate

```bash
echo -n 'the_data' | base64
```

## 🛠️ Configuration
You can modify the config data inside the config folder.





```bash
helm uninstall prometheus -n monitoring
```

# Automate Process with bash script

```bash
./setup-prometheus.sh
```

## 📈 Install Prometheus

```bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring -f config/grafana.yml -f config/prometheus.yml -f config/alert-manager.yml
```

## ⬆️ Upgrade

```bash
helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring -f config/grafana.yml -f config/prometheus.yml -f config/alert-manager.yml
```

## ❌ Uninstall

```bash
helm uninstall prometheus -n monitoring
```

# 🤖 Automate Process with Bash Script

```bash
./setup-prometheus.sh
```