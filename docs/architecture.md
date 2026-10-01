# Architecture Notes

## Purpose

This document describes the intended architecture for the Secure AWS CI/CD Deployment Platform.

The implementation will be completed gradually. At the end of Phase 0, this is a design only.

## Application Traffic Flow

1. A user sends an HTTP request to the public IP address or domain name of the AWS EC2 instance.
2. The AWS Security Group allows only approved inbound traffic, such as HTTP on port 80 and SSH on port 22 from a restricted source.
3. Nginx receives the request on the EC2 instance.
4. Nginx forwards the request to the Flask container through Docker networking.
5. The Flask application sends the response.
6. Nginx returns the response to the user.

## CI/CD Deployment Flow

1. A developer pushes code to the GitHub repository.
2. GitHub Actions runs validation, tests, and linting.
3. GitHub Actions builds a Docker image.
4. Trivy scans the Docker image for known vulnerabilities.
5. GitHub Actions pushes a versioned Docker image to a container registry.
6. GitHub Actions securely connects to the EC2 instance using an SSH key stored in GitHub Secrets.
7. The EC2 server pulls the new image and starts it using Docker Compose.
8. A health check calls the Flask `/health` endpoint.
9. If health validation fails, the rollback script restores the previous working image.

## Planned Security Controls

- GitHub Secrets for SSH keys, tokens, and deployment configuration.
- No secrets committed to Git.
- `.env` ignored by Git.
- Least-privilege Security Group rules.
- Container image scanning with Trivy.
- Versioned Docker images for safer rollback.
- Health checks after deployment.
- CloudWatch monitoring and log collection.

## Current State

Phase 0 is planning only. No AWS resources, containers, CI/CD workflows, or deployed application exist yet.
