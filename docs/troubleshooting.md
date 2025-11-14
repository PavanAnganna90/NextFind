## Troubleshooting Guide

### Authentication
- **Symptom**: Redirect loops or 401 on cart actions  
  **Fix**: Verify `NEXTAUTH_URL` matches the public URL. Ensure Redis is reachable and `NEXTAUTH_SECRET` exists. Clear cookies and restart `pnpm dev`.

### Checkout / Payments
- **Symptom**: Stripe errors during checkout  
  **Fix**: Confirm `STRIPE_SECRET_KEY` and `STRIPE_WEBHOOK_SECRET` are set. In dev mode, run `stripe listen --forward-to localhost:3000/api/webhooks`.

### Database & Cache
- **Symptom**: `ECONNREFUSED` for PostgreSQL  
  **Fix**: `docker compose -f infra/docker/docker-compose.yml ps` to ensure services are running. Apply migrations with `pnpm --filter ./apps/admin prisma migrate deploy`.
- **Symptom**: Stale carts/wishlists  
  **Fix**: Flush Redis (`docker compose -f infra/docker/docker-compose.yml exec redis redis-cli FLUSHALL`) and restart the client app.

### Kubernetes
- **Symptom**: Pods stuck in `ImagePullBackOff`  
  **Fix**: Ensure images exist in the registry and secrets for registry auth are applied (see `infra/kubernetes/base/registry-secret.yaml`).
- **Symptom**: Datadog agent CrashLoop  
  **Fix**: Validate `DATADOG_API_KEY` secret, restart `datadog-agent` DaemonSet, and check `infra/monitoring/datadog-values.yaml` for cluster name mismatches.

### CI/CD
- **Symptom**: GitHub Actions fails on pnpm install  
  **Fix**: Clear lockfile conflicts (`pnpm install --frozen-lockfile` locally) and re-run workflow.
- **Symptom**: Tests hang in CI  
  **Fix**: Ensure Playwright browsers are installed (`npx playwright install --with-deps`) or skip E2E via env flag `SKIP_E2E=true`.

### Logs & Dashboards
- Use `scripts/tail-logs.sh` for aggregated pod logs.
- Datadog dashboards: `infra/monitoring/datadog-dashboard.json`.
- Prometheus rules: `monitoring/prometheus.yml`.

Document any new fixes here so contributors can unblock themselves quickly.

