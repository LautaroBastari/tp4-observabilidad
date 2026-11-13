#!/usr/bin/env bash
# Accesos: Prometheus :9090, Grafana :3000 (admin/admin), API :8080
# Ctrl+C corta los tres
kubectl -n observabilidad port-forward svc/monitoring-kube-prometheus-prometheus 9090:9090 &
kubectl -n observabilidad port-forward svc/monitoring-grafana 3000:80 &
kubectl -n gamecloud port-forward svc/gamecloud-ranking 8080:80 &
trap 'kill $(jobs -p)' INT TERM
wait
