# TP4 - Observabilidad: GameCloud en Kubernetes

Stack de observabilidad para la API de ranking de GameCloud sobre minikube: Prometheus y Grafana (kube-prometheus-stack), Loki y Alloy.

## Contenido

| Carpeta | Contenido |
|---|---|
| `app/` | API de ranking (provista por la cátedra) |
| `charts/gamecloud-ranking/` | Chart de la API, con el ServiceMonitor agregado en `templates/servicemonitor.yaml` |
| `observabilidad/` | Values de kube-prometheus-stack, Loki y Alloy (pipeline de logs) |
| `dashboards/gamecloud-dashboard.json` | Dashboard de Grafana exportado |
| `escenarios/` | Scripts para provocar las fallas y volver a la normalidad |
| `scripts/` | Scripts para reproducir la instalación paso a paso |

## Requisitos

- Docker, minikube, kubectl y helm.
- Versiones de charts: kube-prometheus-stack 92.11.0, loki 7.5.0, alloy 1.14.2.

## Reproducción

Desde la raíz del repositorio:

```bash
# 0. Cluster, repos de helm y namespaces (observabilidad y gamecloud)
bash scripts/00-preparacion.sh

# 1. Imagen y despliegue de la API (release gamecloud-ranking en ns gamecloud)
bash scripts/01-api.sh

# 2. Prometheus + Grafana (release monitoring en ns observabilidad)
bash scripts/02-prometheus-grafana.sh

# 3. ServiceMonitor de la API (helm upgrade del chart)
bash scripts/03-servicemonitor.sh

# 4. Loki + Alloy
bash scripts/04-loki-alloy.sh

# Accesos: Prometheus :9090, Grafana :3000 (admin/admin), API :8080
bash scripts/port-forward.sh
```

Después, en Grafana: Dashboards → New → Import y cargar `dashboards/gamecloud-dashboard.json`.

## Escenarios de falla

```bash
bash escenarios/1_errores.sh        # 20% de respuestas 500
bash escenarios/2_latencia.sh       # +2 s por pedido
bash escenarios/3_crashloop.sh      # pods nuevos en CrashLoopBackOff
bash escenarios/4_puerto_service.sh # targetPort del Service incorrecto
bash escenarios/normal.sh           # vuelve todo a la normalidad
```

Correr `normal.sh` entre un escenario y otro.

## Decisiones principales

- Alertmanager deshabilitado y Grafana con límite de memoria de 512Mi.
- Datasource de Loki declarado en los values de kube-prometheus-stack.
- kubeControllerManager, kubeScheduler y kubeEtcd deshabilitados: en minikube escuchan en 127.0.0.1 y Prometheus no los puede scrapear (aparecían como down).
- El ServiceMonitor lleva el label `release: monitoring`, que es lo que pide el `serviceMonitorSelector` del Prometheus.
- Loki en modo SingleBinary con almacenamiento en filesystem y sin multi-tenancy.
- Alloy agrega los labels namespace, pod, container y app, y `level` (leído del JSON) solo para la API.
