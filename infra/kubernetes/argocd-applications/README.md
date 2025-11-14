# 📊 Argo CD Applications

This directory contains Argo CD Application manifests for GitOps-based deployments.

## 📁 Structure

```
argocd-applications/
├── datadog-application.yaml    # Datadog Agent Helm chart deployment
└── README.md                   # This file
```

## 🚀 Datadog Agent Deployment

### Overview

The Datadog Agent is deployed using the official Datadog Helm chart via Argo CD. This provides:

- **GitOps workflow**: Configuration changes via Git commits
- **Automated sync**: Self-healing and automatic updates
- **Version control**: Helm chart version pinning
- **Easy updates**: Update Helm chart version or values

### Files

- **`datadog-application.yaml`**: Argo CD Application manifest
  - Uses Helm chart: `datadog/datadog` from `https://helm.datadoghq.com`
  - Chart version: `3.74.1` (pinned for stability)
  - Values: Inline configuration (can be moved to separate file)

- **`../monitoring/datadog-values.yaml`**: Helm values file
  - Comprehensive configuration for Datadog Agent
  - Can be referenced from Git repository if using multi-source

### Deployment

1. **Ensure Argo CD is installed and running**

2. **Create Datadog API key Secret**:
   ```bash
   kubectl create namespace monitoring --dry-run=client -o yaml | kubectl apply -f -
   
   kubectl create secret generic datadog-secret \
     --from-literal api-key=<YOUR_DATADOG_API_KEY> \
     -n monitoring
   ```

3. **Apply Argo CD Application**:
   ```bash
   kubectl apply -f datadog-application.yaml
   ```

4. **Verify Deployment**:
   ```bash
   # Check application status
   kubectl get application datadog-agent -n argocd
   
   # View sync status
   kubectl describe application datadog-agent -n argocd
   
   # Check Datadog resources
   kubectl get daemonset datadog-agent -n monitoring
   kubectl get deployment datadog-cluster-agent -n monitoring
   ```

### Configuration

#### Update Helm Chart Version

Edit `datadog-application.yaml`:

```yaml
spec:
  sources:
    - repoURL: https://helm.datadoghq.com
      chart: datadog
      targetRevision: 3.75.0  # Update version here
```

#### Update Configuration

Edit the `values` section in `datadog-application.yaml` or modify `datadog-values.yaml` and reference it.

#### Using Values File from Git Repository

If your values file is in a Git repository, use multi-source approach:

```yaml
spec:
  sources:
    # Helm chart
    - repoURL: https://helm.datadoghq.com
      chart: datadog
      targetRevision: 3.74.1
    # Values file from Git
    - repoURL: https://github.com/your-org/your-repo.git
      targetRevision: main
      path: infra/kubernetes/monitoring
      helm:
        valueFiles:
          - datadog-values.yaml
```

### Sync Policy

The application is configured with:

- **Automated sync**: Enabled
- **Self-healing**: Enabled (auto-syncs when resources are modified)
- **Prune**: Enabled (removes resources not in Git)
- **Auto-create namespace**: Enabled

### Health Checks

The application monitors:

- `datadog-cluster-agent` Deployment in `monitoring` namespace
- `datadog-agent` DaemonSet in `monitoring` namespace

### Troubleshooting

See `DATADOG-HELM-MIGRATION.md` for detailed troubleshooting steps.

## 📚 Additional Resources

- [Argo CD Documentation](https://argo-cd.readthedocs.io/)
- [Datadog Helm Chart](https://github.com/DataDog/helm-charts)
- [Datadog Kubernetes Integration](https://docs.datadoghq.com/containers/kubernetes/)




