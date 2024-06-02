# setup prometheus (kube-prometheus-stack) on k8s

easily setup prometheus(kube-prometheus-stack) on kubernetes and set prometheus, grafana and alertmanager config.

# Manual process

## add repo 

```bash

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

helm repo update
```

## create namespace 

```bash
kubectl create namespace monitoring
```

## add grafana secrets (alert credentials mail, slack ....)

```bash
kubectl apply -f grafana-secret.yml
```

### base64 generate 

```bash
echo -n 'the_data' | base64
```

## config 
you can modify config data inside `config folder`

## install prometheus

```bash
helm install prometheus prometheus-community/kube-prometheus-stack -n monitoring -f config/grafana.yml -f config/prometheus.yml -f config/alert-manager.yml
```

## upgrade

```bash
helm upgrade prometheus prometheus-community/kube-prometheus-stack -n monitoring -f config/grafana.yml -f config/prometheus.yml -f config/alert-manager.yml
```

## uninstall

```bash
helm uninstall prometheus -n monitoring
```

# automate with bash script

```bash
./setup-prometheus.sh
```