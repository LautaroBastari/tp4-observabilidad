#!/usr/bin/env bash
# Etapa 4: Loki (SingleBinary) y Alloy
# helm no logra leer el repo de Grafana desde WSL (timeout), así que se bajan
# los charts empaquetados con curl y se instalan desde el archivo .tgz
set -e
cd "$(dirname "$0")/.."
mkdir -p /tmp/charts-grafana
curl -sSL -o /tmp/charts-grafana/loki-7.5.0.tgz \
  https://github.com/grafana/helm-charts/releases/download/helm-loki-7.5.0/loki-7.5.0.tgz
curl -sSL -o /tmp/charts-grafana/alloy-1.14.2.tgz \
  https://github.com/grafana/helm-charts/releases/download/alloy-1.14.2/alloy-1.14.2.tgz

helm upgrade --install loki /tmp/charts-grafana/loki-7.5.0.tgz -n observabilidad \
  -f observabilidad/values-loki.yaml --wait --timeout 10m
helm upgrade --install alloy /tmp/charts-grafana/alloy-1.14.2.tgz -n observabilidad \
  -f observabilidad/values-alloy.yaml --wait --timeout 5m
kubectl get pods -n observabilidad
