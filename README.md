# Secure AWS CI/CD Deployment Platform

Containerized Flask application deployed on AWS EC2 behind Nginx, with Docker Compose, GitHub Container Registry (GHCR), and automated health‑checked deployments.

## Architecture

- **Application**: Flask app with `/` and `/health` endpoints
- **Runtime**: Gunicorn (WSGI server) in a Docker container
- **Orchestration**: Docker Compose (production config)
- **Reverse proxy**: Nginx (public port 80 → internal `127.0.0.1:5000`)
- **Infrastructure**: AWS EC2 (Ubuntu), Security Groups, UFW
- **Registry**: GitHub Container Registry (versioned images)
- **Deployment**: Bash script with health checks and basic rollback support  

Traffic flow:

```text
Internet
  → AWS Security Group (port 80)
  → UFW (port 80)
  → Nginx
  → Gunicorn (127.0.0.1:5000)
  → Flask app
```

Backend port `5000` is **not** exposed publicly.

## Key Features

- Versioned Docker images in GHCR (e.g. `1.0.1`)
- Health‑checked deployment script:
  - Pulls exact image tag
  - Restarts container via Docker Compose
  - Waits for `/health` to become healthy
  - Prints logs on failure
- Defense‑in‑depth security:
  - SSH restricted to admin IP
  - UFW + Security Group
  - Backend bound to `127.0.0.1` only
- Automated tests with pytest in GitHub Actions

## Repository Structure

- `app/` – Flask application code
- `Dockerfile` – Image build definition
- `compose.yaml` – Local development Compose config
- `compose.production.yaml` – Production deployment config (GHCR image)
- `scripts/deploy.sh` – Health‑checked deployment script
- `.github/workflows/ci.yml` – GitHub Actions CI workflow

## Deployment

### Image

- Registry: GitHub Container Registry
- Image:
  `ghcr.io/vsuman22/secure-aws-ci-cd-deployment-platform:1.0.1`

### EC2 Deployment

On the EC2 instance:

```bash
/opt/secure-devops-platform/scripts/deploy.sh 1.0.1
```

The script:

1. Pulls the specified image from GHCR
2. Starts the service using `compose.production.yaml`
3. Waits for the `/health` endpoint to respond
4. Fails with logs if health checks do not pass

### Public Endpoints

- Health: `http://<EC2_PUBLIC_IP>/health`  
- Root: `http://<EC2_PUBLIC_IP>/`

Backend port `5000` is intentionally not accessible from the internet.

## Security

- SSH (port 22) allowed only from a trusted IP  
- HTTP (port 80) allowed from anywhere (Nginx only)  
- Application port `5000` bound to `127.0.0.1` and blocked by UFW + Security Group  
- No secrets, keys, or credentials committed to the repository  

## CI/CD

- GitHub Actions workflow:
  - Runs on push to `main`
  - Sets up Python 3.12
  - Installs dependencies from `requirements.txt` and `requirements-dev.txt`
  - Runs `pytest` for endpoint tests
  - Builds a local test Docker image

Image build, push to GHCR, and EC2 deployment are currently performed manually with versioned tags, using the same deployment script that CI/CD would call.

- CI is fully automated (tests on every push).
- CD (build/push/deploy) is currently performed manually with versioned images; the `ci-cd.yml` workflow is a work-in-progress.


## Monitoring & Operations

- Docker health checks configured in Compose
- Logs: `docker compose logs`
- CloudWatch integration: planned / basic (adjust to what you actually implemented)

## Cost & Cleanup

- EC2 instance is stopped when not in use to avoid unnecessary charges
- EBS volume persists while stopped; can be deleted when the project is no longer needed  

## Future Enhancements

- Full GitHub Actions CD:
  - Push image to GHCR
  - Trivy vulnerability scanning
  - Automated SSH deploy to EC2
- Terraform for infrastructure as code
- HTTPS with Let’s Encrypt
- CloudWatch dashboards and alarms

## Troubleshooting & Incidents

### Incident 1: SSH connection timed out

Symptom: `ssh: connect to host <IP> port 22: Connection timed out`
Cause: Security Group SSH rule had an old public IP.
Resolution: Updated SSH source to “My IP” in the Security Group.
Prevention: Always re-check public IP and Security Group after network changes.

### Incident 2: GHCR push failed with permission_denied

Symptom: `denied: permission_denied: write_package` in GitHub Actions.
Cause: Workflow lacked write permission for packages.
Resolution: Enabled “Read and write permissions” in repo Actions settings and used a minimal workflow; ultimately performed manual GHCR push with PAT.
Prevention: Verify workflow permissions and test with a minimal workflow early.


## Author

Suman V – B.Tech CSE 2026 – DevOps / Cloud Engineer aspirant
GitHub: https://github.com/vsuman22
