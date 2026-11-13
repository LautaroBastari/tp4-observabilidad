#!/usr/bin/env bash
# Etapa 2: kube-prometheus-stack con valores propios
set -e
cd "$(dirname "$0")/.."
helm upgrade --install monitoring prometheus-community/kube-prometheus-stack \
  --version 92.11.0 -n observabilidad \
  -f observabilidad/values-kube-prometheus-stack.yaml --wait --timeout 10m
kubectl get pods -n observabilidad
