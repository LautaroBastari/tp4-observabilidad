#!/usr/bin/env bash
# Etapa 0: minikube, repos de Helm y namespaces
set -e
minikube start --cpus 4 --memory 8192 --driver docker
kubectl get nodes
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm repo list
kubectl create namespace observabilidad --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace gamecloud --dry-run=client -o yaml | kubectl apply -f -
kubectl get ns
