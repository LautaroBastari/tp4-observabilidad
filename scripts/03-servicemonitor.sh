#!/usr/bin/env bash
# Etapa 3: actualizar el release de la API (ahora el CRD existe y se crea el ServiceMonitor)
set -e
cd "$(dirname "$0")/.."
helm upgrade gamecloud-ranking charts/gamecloud-ranking -n gamecloud --wait
kubectl get servicemonitor -n gamecloud
kubectl get prometheus -n observabilidad -o jsonpath='{.items[0].spec.serviceMonitorSelector}{"\n"}'
