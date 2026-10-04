# Secure AWS CI/CD Deployment Platform

A production-inspired DevOps portfolio project that deploys a small containerized Flask web application to AWS EC2 through a secure CI/CD pipeline.

The application itself will stay intentionally simple so the project can focus on practical DevOps and cloud engineering skills: Linux administration, Docker, GitHub Actions, AWS EC2, Nginx, image security scanning, secrets handling, CloudWatch monitoring, health checks, rollback, and troubleshooting.

## Project Goal

Build a secure automated deployment platform with the following workflow:

```text
Developer Git push
        ↓
GitHub Actions CI pipeline
        ↓
Test / lint application
        ↓
Build Docker image
        ↓
Trivy image security scan
        ↓
Push versioned image to container registry
        ↓
Deploy to AWS EC2 using SSH
        ↓
Docker Compose starts the application
        ↓
Nginx routes traffic to the application
        ↓
Health check validates deployment
        ↓
CloudWatch monitors the EC2 instance and logs
        ↓
Rollback runs if deployment fails
```

## Planned Tech Stack

| Area | Technology |
|---|---|
| Application | Python Flask |
| Operating system | Ubuntu Linux on AWS EC2 |
| Source control | Git and GitHub |
| Containerization | Docker and Docker Compose |
| CI/CD | GitHub Actions |
| Container registry | Docker Hub or GitHub Container Registry |
| Reverse proxy | Nginx |
| Cloud platform | AWS EC2, IAM, Security Groups, CloudWatch |
| Security scanning | Trivy |
| Automation | Bash scripting |
| Infrastructure as Code | Terraform, added only after manual AWS deployment works |

## Planned Architecture

```text
Internet User
    ↓
AWS EC2 Security Group
    ↓
Nginx Reverse Proxy
    ↓
Flask Application Container
    ↓
Docker Network
```

The CI/CD path will be:

```text
Developer → GitHub Repository → GitHub Actions → Container Registry
                                             ↓
                                      SSH deployment to EC2
                                             ↓
                                  Docker Compose + Nginx
```

## Planned Features

- Flask application with a `/health` endpoint
- Dockerized application
- Docker Compose deployment
- Nginx reverse proxy
- Immutable Docker image version tags
- GitHub Actions CI/CD workflow
- Trivy container image scanning
- GitHub Secrets for sensitive configuration
- AWS EC2 deployment using SSH
- Deployment health checks
- Rollback script for failed deployments
- CloudWatch monitoring and logs
- Security and troubleshooting documentation
- Terraform enhancement after the manual setup is complete

## Local Docker Compose Workflow

The application can be built, deployed, health-checked, and stopped locally using Docker Compose and Bash scripts.

### Start or redeploy locally

```bash
./scripts/deploy-local.sh
```

This script builds the Docker image, starts the Docker Compose service, and retries the Flask `/health` endpoint until the application is ready.

### Check application health

```bash
./scripts/health-check.sh
```

Expected successful response:

```json
{
  "application": "secure-aws-ci-cd-deployment-platform",
  "status": "healthy",
  "version": "1.0.0"
}

### Stop the local deployment

```bash
./scripts/stop-local.sh
```

This stops and removes the Docker Compose application container and its default Docker network. The Docker image remains locally available.

### Local Service Configuration

| Setting | Default value | Purpose |
|---|---:|---|
| Host port | `5000` | Local port used to access the application |
| Container port | `5000` | Port on which Flask listens inside the container |
| Image tag | `1.0.0` | Current local application image version |
| Health endpoint | `/health` | Used for Docker and Bash deployment validation |
| Restart policy | `unless-stopped` | Restarts the container after an unexpected exit or Docker restart |

### Local Verification Commands

```bash
docker compose ps
curl http://localhost:5000/health
docker inspect --format '{{.State.Health.Status}}' secure-aws-ci-cd-platform-app
docker compose logs --tail=50 app
```

## Project Status

Current phase: **Phase 0 — Planning, repository setup, Git, README, and architecture**

| Phase | Topic | Status |
|---|---|---|
| 0 | Planning, repository, Git, README, architecture | In progress |
| 1 | Flask application and Docker | Not started |
| 2 | Docker Compose and Bash scripts | Complete |
| 3 | AWS EC2 Linux server setup | Not started |
| 4 | Nginx reverse proxy | Not started |
| 5 | Container registry and image versioning | Not started |
| 6 | GitHub Actions CI/CD deployment | Not started |
| 7 | Trivy, secrets, and security basics | Not started |
| 8 | CloudWatch monitoring | Not started |
| 9 | Health checks, rollback, incidents, troubleshooting | Not started |
| 10 | Terraform infrastructure enhancement | Not started |

## Security Principles

- Never commit `.env` files, passwords, API keys, tokens, private keys, or AWS credentials.
- Use GitHub Secrets for CI/CD credentials.
- Restrict EC2 Security Group access to the minimum required ports.
- Use image scanning before publishing container images.
- Use versioned image tags instead of deploying only `latest`.
- Keep secrets out of logs, screenshots, Git history, and documentation.

## Cost Safety

AWS infrastructure will not be created during Phase 0.

When AWS resources are created in later phases, the project will use cost-conscious choices and document cleanup steps. The EC2 instance will be stopped or terminated when not actively being used.

## Architecture Documentation

- [Architecture notes](docs/architecture.md)
- [Architecture diagram source](diagrams/architecture.md)

## Learning Objectives

By completing this project, I will practice:

- Linux server administration
- Git and GitHub workflows
- Docker and Docker Compose
- CI/CD using GitHub Actions
- AWS EC2 deployment and basic IAM
- Nginx reverse proxy configuration
- Container image scanning with Trivy
- Secrets management
- CloudWatch monitoring
- Bash automation
- Health checks, rollback, and incident troubleshooting

## Author

SUMAN V
B.Tech CSE Fresher | Aspiring DevOps / Cloud Engineer
