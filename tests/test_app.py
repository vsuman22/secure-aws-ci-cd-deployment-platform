from app.app import app


def test_root_endpoint():
    client = app.test_client()

    response = client.get("/")

    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "running"
    assert data["message"] == "Secure AWS CI/CD Deployment Platform"


def test_health_endpoint():
    client = app.test_client()

    response = client.get("/health")

    assert response.status_code == 200
    data = response.get_json()
    assert data["status"] == "healthy"
    assert data["application"] == "secure-aws-ci-cd-deployment-platform"
