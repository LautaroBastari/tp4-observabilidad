#!/usr/bin/env bash
# Etapa 1: imagen de la API dentro de minikube + chart
set -e
cd "$(dirname "$0")/.."
minikube image build -t gamecloud-ranking:1.0 app/
helm upgrade --install gamecloud-ranking charts/gamecloud-ranking -n gamecloud --wait
kubectl get pods,svc -n gamecloud
