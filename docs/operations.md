## Operations Guide

### Prerequisites
- Node.js 20+, pnpm 9+
- Docker Desktop or access to a Kubernetes cluster (kind, Minikube, EKS, etc.)
- Stripe, Postgres, Redis, and Datadog credentials if you plan to exercise those integrations.

### Environment Variables
Copy `.env.example` to `.env` and fill the following keys:

| Key | Purpose |
| --- | --- |
| `DATABASE_URL` | PostgreSQL connection string |
| `REDIS_URL` | Session + cart cache |
| `NEXTAUTH_SECRET` | Auth encryption |
| `STRIPE_SECRET_KEY` | Checkout processing |
| `DATADOG_API_KEY` | Monitoring metrics |

Use `apps/*/.env.example` for surface-specific overrides when applicable.

### Running Locally
```bash
pnpm install
docker compose -f infra/docker/docker-compose.yml up -d postgres redis
pnpm --filter ./apps/admin dev
pnpm --filter ./apps/client dev
```

### Tests & Quality Gates
```bash
pnpm lint
pnpm test
```
Add component/unit tests for every change; use `pnpm --filter ./apps/client test -- --watch` for local loops.

### Docker Images
```bash
docker build -t nextfind/admin -f apps/admin/Dockerfile .
docker build -t nextfind/client -f apps/client/Dockerfile .
docker compose -f infra/docker/docker-compose.prod.yml up -d
```

### Kubernetes Deployment
```bash
kubectl config use-context <cluster>
kubectl apply -k infra/kubernetes/overlays/dev   # or prod
```

Key manifests:
- `infra/kubernetes/base`: shared deployments/services
- `infra/kubernetes/overlays/*`: replicas, HPA, ingress, secrets
- `infra/monitoring/datadog-values.yaml`: Datadog agent Helm values

### Observability
- Datadog: apply operator manifests + values file
- Prometheus/Grafana: use `infra/monitoring/prometheus.yml` and `grafana/` dashboards
- Alerts: configure via Datadog monitors or Prometheus rules `monitoring/alertmanager.yml`

### Deployment Checklist
1. `pnpm lint && pnpm test`
2. `docker compose -f infra/docker/docker-compose.yml build` or `docker build` for individual apps
3. Push images to GHCR or Docker Hub
4. `kubectl apply -k infra/kubernetes/overlays/prod`
5. Run smoke tests (`scripts/smoke-check.sh`) and verify Datadog dashboards

### Incident Playbook
1. Check GitHub Actions run for the commit.
2. Inspect Datadog dashboards for error rate or latency spikes.
3. Use `kubectl describe pod <name>` and `kubectl logs -f <pod>` for root cause.
4. Roll back with `kubectl rollout undo deployment/<name>` or apply the previous Kustomize snapshot.
5. Document learnings in `docs/troubleshooting.md`.

