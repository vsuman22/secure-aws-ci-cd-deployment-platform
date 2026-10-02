import os
from flask import Flask, jsonify

app = Flask(__name__)

APP_NAME = "secure-aws-ci-cd-deployment-platform"
APP_VERSION = os.getenv("APP_VERSION", "1.0.0")


@app.get("/")
def home():
    return jsonify(
        {
            "message": "Secure AWS CI/CD Deployment Platform",
            "status": "running",
        }
    ), 200


@app.get("/health")
def health_check():
    return jsonify(
        {
            "status": "healthy",
            "application": APP_NAME,
            "version": APP_VERSION,
        }
    ), 200


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
