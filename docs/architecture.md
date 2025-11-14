## Architecture Overview

### System Goals
- Multi-surface e-commerce platform (storefront + admin).
- Observable, autoscalable infrastructure that works on Docker or Kubernetes.
- Clear separation between UI, API, and data layers for faster iteration.

### Component Map
| Layer | Components | Notes |
| --- | --- | --- |
| Presentation | `apps/client`, `apps/admin` | Next.js 14, Tailwind, Shadcn/ui |
| API & Services | `services/api`, server actions | FastAPI microservices, Stripe hooks, background jobs |
| Data & Cache | PostgreSQL, Redis | Provisioned via Docker Compose for local dev, Helm/Kustomize for clusters |
| Observability | Datadog, Prometheus/Grafana | Dashboards + alerting manifests in `infra/monitoring` |
| Delivery | GitHub Actions, Turborepo, Docker, K8s | Multi-stage pipelines and deployment overlays |

### Data Flow
1. Shopper/Admin issues request to respective Next.js app.
2. App calls FastAPI gateway or server actions for product/catalog/cart operations.
3. Gateway reads from PostgreSQL (products, orders) and Redis (sessions, carts).
4. Events and metrics flow to Datadog and Prometheus.
5. GitHub Actions build/publish container images and apply manifests to the chosen cluster.

### Environments
| Environment | Stack | Notes |
| --- | --- | --- |
| Local | Docker Compose + pnpm dev | Fastest feedback loop |
| Dev/Staging | Kubernetes overlay (`infra/kubernetes/overlays/dev`) | Mirrors prod features with fewer replicas |
| Production | Kubernetes overlay (`infra/kubernetes/overlays/prod`) | Autoscaling, network policies, monitoring |

### Security & Compliance
- Secrets loaded via `.env` locally and Kubernetes Secrets in production.
- Role-based admin APIs, NextAuth-compatible flows, and Redis token invalidation.
- CI enforces lint/test before image build; CodeQL/Dependabot can be toggled per repo settings.

For deeper deployment steps, read `docs/operations.md`. Troubleshooting guidance is in `docs/troubleshooting.md`.

