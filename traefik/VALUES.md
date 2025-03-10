# 📜 VALUES.md  
**Helm Chart:** `customer-support-panel-frontend`  
**Description:** A Helm Chart for deploying the Customer Support Panel Frontend on Kubernetes.  

---

## 📌 Configuration Parameters in `values.yaml`

| Parameter                        | Default Value                                    | Description |
|----------------------------------|------------------------------------------------|-------------|
| **Global Settings** | | |
| `global` | `{}` | Global values for the Helm Chart |
| **Monitoring Settings** | | |
| `serviceMonitor.enabled` | `false` | Enable/Disable ServiceMonitor for Prometheus monitoring |
| **Storage Settings** | | |
| `persistence.enabled` | `false` | Enable/Disable persistent volume |
| **Security Settings** | | |
| `unique-user` | `10037` | UID for running the container |
| **CronJob Settings** | | |
| `cronjob.enabled` | `false` | Enable/Disable CronJob |
| `cronjob.schedule` | `"0 */12 * * *"` | CronJob execution schedule (default: every 12 hours) |
| **ConfigMap Settings** | | |
| `configmap.enabled` | `true` | Enable/Disable ConfigMap |
| `configmap.data.conf` | JSON configuration | Configuration data containing authentication and API settings |
| **Secret Settings** | | |
| `secret.enabled` | `false` | Enable/Disable Secret |
| `externalSecret.enabled` | `false` | Enable ExternalSecret |
| `externalSecret.secretPath` | `/prod/applications/customer-support-panel-frontend` | Secret path in SecretStore |
| **Container Image Settings** | | |
| `image.registry` | `375424272383.dkr.ecr.ap-southeast-1.amazonaws.com` | Docker Registry URL |
| `image.repository` | `customer` | Image repository name |
| `image.tag` | `vi-prod-v0.0.44` | Image tag |
| `image.pullPolicy` | `IfNotPresent` | Image pull policy |
| **Replica Settings** | | |
| `replicaCount` | `1` | Default number of replicas |
| **Service Settings** | | |
| `service.type` | `ClusterIP` | Service type (`ClusterIP`, `NodePort`, `LoadBalancer`) |
| `service.ports` | `80` | Service port |
| **Ingress Settings** | | |
| `ingress.enabled` | `false` | Enable/Disable Ingress |
| `ingress.hostname` | `customer-support-front.prod.liobank.vn` | Ingress domain |
| **Istio VirtualService Settings** | | |
| `istio.enabled` | `true` | Enable/Disable Istio VirtualService |
| `istio.spec.gateways` | `["istio-system/ingress"]` | Istio Gateway configuration |
| `istio.spec.hosts` | `["customer-support-front.prod.liobank.vn"]` | Hostnames managed by Istio |
| **ArgoCD Settings** | | |
| `argocd.enabled` | `true` | Enable/Disable ArgoCD integration |
| `argocd.namespace` | `"argocd"` | ArgoCD namespace |
| `argocd.project` | `"customer-support"` | ArgoCD project name |
| `argocd.projectEnabled` | `true` | Enable/Disable creation of an ArgoCD AppProject |
| `argocd.repoURL` | `"https://github.com/fintech-farm/customer-support-panel-frontend.git"` | Git repository containing the Helm Chart |
| `argocd.targetRevision` | `"main"` | Git branch/tag to sync |
| `argocd.automated.prune` | `true` | Remove resources that are no longer in Git |
| `argocd.automated.selfHeal` | `true` | Automatically fix any discrepancies with Git |
| **Autoscaling Settings** | | |
| `autoscaling.enabled` | `false` | Enable/Disable Horizontal Pod Autoscaler (HPA) |
| `autoscaling.minReplicas` | `1` | Minimum number of replicas |
| `autoscaling.maxReplicas` | `4` | Maximum number of replicas |
| `autoscaling.metrics` | `{}` | Autoscaling metrics (CPU, Memory) |
| **Resource Limits & Requests** | | |
| `resources.limits.memory` | `512Mi` | Maximum memory limit |
| `resources.requests.memory` | `512Mi` | Minimum memory request |
| **Security Context Settings** | | |
| `podSecurityContext.enabled` | `false` | Enable/Disable pod security context |
| `containerSecurityContext.enabled` | `false` | Enable/Disable container security context |
| **Update Strategy Settings** | | |
| `updateStrategy.type` | `RollingUpdate` | Pod update strategy |
| **Probes Settings** | | |
| `livenessProbe.enabled` | `false` | Enable/Disable Liveness Probe |
| `readinessProbe.enabled` | `false` | Enable/Disable Readiness Probe |

---

## 🚀 Usage Guide

### 🔧 1. Installing the Helm Chart
```sh
helm install customer-support-panel-frontend ./customer-support-panel-frontend -n fintech-farm
