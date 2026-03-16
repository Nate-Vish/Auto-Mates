# DevOps & Cloud Essentials
**When to use:** Read when containerizing apps, setting up CI/CD pipelines, working with cloud services, or configuring monitoring.

---

## Cloud Platform Overview

| Provider | Market Share | Strength |
|----------|-------------|----------|
| **AWS** | ~29% | Broadest service catalog (200+), most mature |
| **Azure** | ~20% | Microsoft/enterprise integration, OpenAI partnership |
| **GCP** | ~13% | Kubernetes leadership, data/ML excellence |

### Key Services Comparison
| Category | AWS | Azure | GCP |
|---|---|---|---|
| Compute | EC2, Fargate | VMs, Container Apps | Compute Engine, Cloud Run |
| Serverless | Lambda | Azure Functions | Cloud Functions |
| Object Storage | S3 | Blob Storage | Cloud Storage |
| SQL Database | RDS, Aurora | Azure SQL | Cloud SQL, AlloyDB |
| Container Orchestration | EKS, ECS | AKS | GKE (gold standard) |
| Monitoring | CloudWatch, X-Ray | Azure Monitor | Cloud Monitoring |

---

## Docker Best Practices

```dockerfile
# 1. Specific base image (never :latest)
FROM node:22-alpine AS builder
WORKDIR /app

# 2. Copy deps first for layer caching
COPY package.json package-lock.json ./
RUN npm ci --only=production

# 3. Copy source after dependencies
COPY . .
RUN npm run build

# 4. Multi-stage: minimal production image
FROM node:22-alpine AS production
WORKDIR /app
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules

# 5. Non-root user
RUN addgroup -g 1001 appgroup && adduser -u 1001 -G appgroup -D appuser
USER appuser

# 6. Health check
HEALTHCHECK --interval=30s --timeout=3s CMD wget -qO- http://localhost:3000/health || exit 1
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

| Principle | Why |
|-----------|-----|
| Multi-stage builds | Reduces image size 60-80% |
| Copy deps before source | Dependency layer caches until package files change |
| Alpine/slim bases | Smaller attack surface |
| Non-root USER | Limits damage from container breakout |
| Specific tags | Reproducible builds |
| .dockerignore | Exclude node_modules, .git, .env |

### docker-compose for Development
```yaml
services:
  app:
    build: .
    ports: ["3000:3000"]
    volumes:
      - .:/app
      - /app/node_modules  # Preserve container's node_modules
    environment:
      - DATABASE_URL=postgres://user:pass@db:5432/mydb
    depends_on:
      db: { condition: service_healthy }

  db:
    image: postgres:16-alpine
    environment: { POSTGRES_USER: user, POSTGRES_PASSWORD: pass, POSTGRES_DB: mydb }
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U user"]
      interval: 5s; retries: 5
    volumes: [pgdata:/var/lib/postgresql/data]

volumes: { pgdata: }
```

---

## Kubernetes Basics

| Concept | What It Is |
|---------|-----------|
| **Pod** | Smallest deployable unit — one or more containers |
| **Deployment** | Declares desired state (replicas, image, update strategy) |
| **Service** | Stable network endpoint for pods |
| **Ingress** | HTTP/HTTPS routing rules (hostname → service) |
| **ConfigMap** | Non-sensitive configuration |
| **Secret** | Sensitive data (use with external secret managers in production) |
| **HPA** | Horizontal Pod Autoscaler |

```bash
kubectl get pods -A                        # All namespaces
kubectl describe pod <name>               # Detailed pod info + events
kubectl logs <pod> -f                     # Stream logs
kubectl exec -it <pod> -- /bin/sh         # Shell into a pod
kubectl rollout undo deployment/<name>    # Rollback to previous version
kubectl top pods                          # Resource usage
```

---

## Infrastructure as Code (Terraform)

```hcl
provider "aws" { region = "us-east-1" }

resource "aws_s3_bucket" "assets" {
  bucket = "myapp-assets-prod"
  tags = { Environment = "production", ManagedBy = "terraform" }
}

variable "environment" { type = string; default = "dev" }
output "bucket_arn" { value = aws_s3_bucket.assets.arn }
```

**Best practices:**
1. Remote state in S3 + DynamoDB locking — never in git
2. Modular design — reusable modules for VPC, databases, compute
3. `terraform plan` before every `apply` — use in CI for PR checks
4. Tag all resources: owner, environment, cost-center, app
5. Use OpenTofu for open-source guarantees on new projects

---

## CI/CD Pipelines

### Standard Pipeline
```
lint → type-check → test → build → scan → deploy
```

### GitHub Actions
```yaml
name: CI
on:
  push: { branches: [main] }
  pull_request: { branches: [main] }

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with: { node-version: 20, cache: "npm" }
      - run: npm ci
      - run: npx tsc --noEmit
      - run: npm run lint
      - run: npm test
      - run: npm run build
```

**Best practices:**
- Treat pipeline config as code — version-controlled, reviewed in PRs
- Cache dependencies aggressively
- Run security scans (SAST, container image scanning) in every pipeline
- Keep secrets in CI platform's secret store, never in pipeline files

---

## Monitoring & Observability

### Three Pillars
| Pillar | Tool | Purpose |
|--------|------|---------|
| **Metrics** | Prometheus + Grafana | Numeric measurements over time |
| **Logs** | Loki (or ELK) | Structured event records |
| **Traces** | Tempo + OpenTelemetry | Request flow across services |

### Four Golden Signals (Google SRE)
```
1. Latency    — How long requests take (p50, p95, p99)
2. Traffic    — Request volume (requests/sec)
3. Errors     — Error rate (5xx responses / total)
4. Saturation — Resource utilization (CPU, memory, disk)
```

### OpenTelemetry
- Vendor-neutral standard for traces, metrics, and logs
- Auto-instrumentation for Node.js, Python, Java, Go
- OTel Collector: receives, processes, exports telemetry to any backend
- Produces trace IDs that correlate logs, metrics, and traces

---

## Scaling Patterns

### Horizontal vs Vertical
| | Horizontal (Scale Out) | Vertical (Scale Up) |
|-|----------------------|---------------------|
| Method | Add more instances | Add more CPU/RAM |
| Limit | Nearly unlimited | Hardware ceiling |
| Complexity | Requires stateless design | Simple but has limits |
| Best for | Web servers, APIs, workers | Databases (initially) |

**Design rule:** Applications must be stateless for horizontal scaling. Store state in databases, caches, or object storage.

### Database Scaling
- **Read replicas:** Route read queries to replicas, writes to primary
- **Connection pooling:** PgBouncer (PostgreSQL) — don't let every app instance open raw connections
- **Caching layer:** Redis/Memcached for hot data

---

## Security in DevOps

```
Secrets Management: HashiCorp Vault, AWS Secrets Manager, SOPS, Doppler
```

**Security checklist:**
- Never commit secrets to git — use `gitleaks` pre-commit scanning
- Scan container images for vulnerabilities (Trivy, Snyk)
- Least privilege for IAM roles, DB users, service accounts
- Rotate secrets regularly; use dynamic/short-lived credentials
- Automate dependency updates (Dependabot or Renovate)
- Enable audit logging on all cloud accounts and critical services

---

## Linux Essentials

```bash
# Process management
ps aux; top/htop; kill -9 <PID>; lsof -i :3000

# File operations
ls -la; find . -name "*.log"; du -sh *; chmod 600 .env

# Networking
curl -v https://api.example.com; ss -tlnp; dig example.com

# SSH
ssh -i ~/.ssh/key.pem user@server; ssh-keygen -t ed25519; scp file.txt user@server:/path/

# systemd
systemctl start/stop/restart/status nginx; journalctl -u nginx -f
```

---

## Daily Rules

1. Containerize everything — `Dockerfile` + `docker-compose.yml` from day one
2. Infrastructure as code — never click through cloud consoles for production resources
3. CI/CD is non-negotiable — no manual deployments to production
4. Monitor from the start — health check endpoints, structured logging, basic metrics
5. Least privilege always — minimal IAM permissions, non-root containers, encrypted secrets
6. Design for horizontal scale — stateless services, external state stores, connection pooling
7. Master one cloud deeply, understand all three — map AWS services to GCP/Azure equivalents
8. Instrument with OpenTelemetry; visualize with Grafana
9. Security in the pipeline — scan images, rotate secrets, update dependencies
