# 📊 Datadog Helm Chart Migration Guide

## 🎯 Overview

This guide documents the migration from manual Datadog Kubernetes manifests to Helm chart deployment via Argo CD.

## ✅ What's Changed

### Before (Manual Manifests)
- Manual DaemonSet and Deployment YAML files
- Datadog Operator with Custom Resources
- Multiple separate configuration files
- Manual kubectl apply process

### After (Helm + Argo CD)
- Official Datadog Helm chart (`datadog/datadog`)
- Argo CD Application for GitOps deployment
- Centralized Helm values file
- Automated sync and self-healing

## 📁 New File Structure

```
infra/kubernetes/
├── argocd-applications/
│   └── datadog-application.yaml    # Argo CD Application manifest
└── monitoring/
    └── datadog-values.yaml         # Helm values file (updated)
```

## 🚀 Deployment Steps

### 1. Prerequisites

Ensure you have:
- Argo CD installed and configured
- Kubernetes cluster access
- Datadog API key

### 2. Create/Verify Datadog Secret

The Helm chart expects a Secret with your Datadog API key:

```bash
kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -

kubectl create secret generic datadog-secret \
  --from-literal api-key=<YOUR_DATADOG_API_KEY> \
  -n monitoring \
  --dry-run=client -o yaml | kubectl apply -f -
```

### 3. Deploy Argo CD Application

Apply the Argo CD Application manifest:

```bash
kubectl apply -f infra/kubernetes/argocd-applications/datadog-application.yaml
```

### 4. Verify Deployment

Check Argo CD Application status:

```bash
kubectl get application datadog-agent -n argocd

# View details
kubectl describe application datadog-agent -n argocd
```

Check Datadog resources:

```bash
# Check DaemonSet
kubectl get daemonset datadog-agent -n monitoring

# Check Cluster Agent
kubectl get deployment datadog-cluster-agent -n monitoring

# Check Pods
kubectl get pods -n monitoring -l app=datadog-agent
```

## 🗑️ Removing Old Datadog Manifests

### Files to Remove

The following files should be removed as they're replaced by the Helm chart:

```bash
# Navigate to monitoring directory
cd infra/kubernetes/monitoring

# Remove old Datadog manifests
rm -f datadog.yaml
rm -f datadog-operator.yaml
rm -f datadog-agent-cr.yaml
rm -f datadog-agent-simple-cr.yaml
rm -f datadog-cluster-agent.yaml
rm -f datadog-simple.yaml
rm -f deploy-datadog-operator.sh
```

### Remove from Kustomization (if applicable)

If these files are referenced in any `kustomization.yaml`, remove the references:

```yaml
# Remove from kustomization.yaml resources list
# resources:
#   - datadog.yaml           # REMOVE THIS
#   - datadog-operator.yaml  # REMOVE THIS
```

### Cleanup Script

A cleanup script is provided: `infra/kubernetes/scripts/remove-old-datadog.sh`

```bash
chmod +x infra/kubernetes/scripts/remove-old-datadog.sh
./infra/kubernetes/scripts/remove-old-datadog.sh
```

## 🔧 Configuration

### Helm Values File

Edit `infra/kubernetes/monitoring/datadog-values.yaml` to customize:

- Resource limits
- Feature flags (APM, logs, process agent, etc.)
- Tags and metadata
- Cluster-specific settings

### Argo CD Application

Edit `infra/kubernetes/argocd-applications/datadog-application.yaml` to:

- Change Helm chart version
- Update sync policy
- Modify health checks
- Adjust resource paths

## 📊 Verification

### Check Datadog Dashboard

1. Log into Datadog
2. Navigate to Infrastructure → Containers
3. Verify nodes and pods are visible
4. Check APM traces if enabled

### Verify Logs Collection

```bash
# Check agent logs
kubectl logs -n monitoring -l app=datadog-agent --tail=50

# Check cluster agent logs
kubectl logs -n monitoring deployment/datadog-cluster-agent --tail=50
```

### Verify Metrics

```bash
# Port forward to check agent health
kubectl port-forward -n monitoring daemonset/datadog-agent 5555:5555

# In another terminal
curl http://localhost:5555/health
```

## 🔄 Updating the Deployment

### Update Helm Chart Version

Edit `datadog-application.yaml`:

```yaml
spec:
  source:
    targetRevision: 3.75.0  # Update version
```

Argo CD will automatically sync if `automated` sync is enabled.

### Update Values

Edit `infra/kubernetes/monitoring/datadog-values.yaml` and commit to Git. Argo CD will detect changes and sync automatically.

### Manual Sync

If auto-sync is disabled:

```bash
argocd app sync datadog-agent
```

Or via kubectl:

```bash
kubectl patch application datadog-agent -n argocd \
  --type merge \
  -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}'
```

## 🐛 Troubleshooting

### Application Stuck in Progressing

```bash
# Check application status
kubectl describe application datadog-agent -n argocd

# Check for errors in pods
kubectl get pods -n monitoring -l app=datadog-agent

# Check events
kubectl get events -n monitoring --sort-by='.lastTimestamp'
```

### Secret Not Found

Ensure the secret exists:

```bash
kubectl get secret datadog-secret -n monitoring

# If missing, create it
kubectl create secret generic datadog-secret \
  --from-literal api-key=<YOUR_API_KEY> \
  -n monitoring
```

### Chart Pull Errors

Verify Helm repository access:

```bash
helm repo add datadog https://helm.datadoghq.com
helm repo update
helm search repo datadog/datadog
```

### Sync Conflicts

If resources conflict with old manifests:

1. Delete old resources manually:
   ```bash
   kubectl delete daemonset datadog-agent -n monitoring
   kubectl delete deployment datadog-cluster-agent -n monitoring
   ```

2. Let Argo CD recreate them via Helm chart

## 📚 Additional Resources

- [Datadog Helm Chart Documentation](https://docs.datadoghq.com/containers/kubernetes/installation/)
- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [GitOps Best Practices](https://www.weave.works/technologies/gitops/)

## ✅ Migration Checklist

- [ ] Argo CD installed and accessible
- [ ] Datadog API key secret created
- [ ] Old Datadog manifests backed up (optional)
- [ ] Argo CD Application created
- [ ] Application synced successfully
- [ ] Datadog DaemonSet and Cluster Agent running
- [ ] Old manifests removed from repository
- [ ] Old manifests removed from Kustomization (if applicable)
- [ ] Datadog dashboard showing cluster data
- [ ] Logs and metrics flowing to Datadog
- [ ] Documentation updated




