# Flask Application with CI/CD on AWS EKS

This project demonstrates a complete CI/CD pipeline for deploying a Flask application to **Amazon Elastic Kubernetes Service (EKS)** using **GitHub Actions**, **AWS Elastic Container Registry (ECR)**, and **Kubernetes**.

---

## Project Overview

* **Application**: A simple Flask app with Redis integration to track page visits.
* **Containerization**: Dockerized Flask app.
* **Orchestration**: Kubernetes (EKS) with Deployment & Service manifests.
* **CI/CD Pipeline**: GitHub Actions workflow to build, scan, push, and deploy automatically.

---

## Directory Structure

```
.flaskapp/
│-- .github/workflows/
│   └── ci-cd.yml           # GitHub Actions workflow
│-- k8s/
│   ├── deployment.yaml     # Kubernetes Deployment manifest
│   └── service.yaml        # Kubernetes Service manifest
│-- .dockerignore           # Files ignored in Docker build
│-- Dockerfile              # Multi-stage Docker build
│-- app.py                  # Flask application code
│-- docker-compose.yml      # Local development with Redis
│-- requirements.txt        # Python dependencies
```

---

## GitHub Secrets Used

The following secrets must be configured in your GitHub repository:

* **AWS_ACCESS_KEY_ID** → IAM user access key
* **AWS_SECRET_ACCESS_KEY** → IAM user secret
* **AWS_ACCOUNT_ID** → Your AWS account ID
* **AWS_REGION** → AWS region (e.g., `ap-south-1`)
* **ECR_REPO** → ECR repository name (e.g., `flaskapp`)
* **ECR_URI** → Full ECR URI (`<account-id>.dkr.ecr.<region>.amazonaws.com/<repo>`)
* **KUBECONFIG** → Base64 encoded kubeconfig for the EKS cluster

---

## CI/CD Workflow (`ci-cd.yml`)

The pipeline consists of the following stages:

1. **Checkout code** → Pulls repository code.
2. **Build Docker image** → Builds Flask app image.
3. **Scan Docker image** → Security scan with Trivy.
4. **Configure AWS credentials** → Authenticates with AWS.
5. **Login to AWS ECR** → Docker login for ECR.
6. **Push Docker image** → Pushes image to AWS ECR.
7. **Deploy to Amazon EKS** → Applies Kubernetes manifests (Deployment & Service).

---

## Docker Setup

**Dockerfile** uses a two-stage build:

* **Stage 1**: Installs dependencies.
* **Stage 2**: Copies app and runs Flask.

Build and run locally:

```bash
docker build -t flaskapp:latest .
docker run -p 5000:5000 flaskapp:latest
```

---

## Kubernetes Deployment

### Deployment (`deployment.yaml`)

* Deploys **Flask container** from ECR image.
* Exposes port **5000**.

### Service (`service.yaml`)

* Type: **LoadBalancer** → Exposes app publicly.
* Maps port **5000** → Flask container port.

Apply manually:

```bash
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
```

Check resources:

```bash
kubectl get pods
kubectl get svc
```

---

## Accessing the App

Once deployed, get the LoadBalancer URL:

```bash
kubectl get svc flask-service
```


<img width="1751" height="68" alt="image" src="https://github.com/user-attachments/assets/67122bb2-3676-4da1-b80a-765b65621628" />


Then open:

```
http://<EXTERNAL-IP>:5000
```

---

## Local Development with Docker Compose

```bash
docker-compose up --build
```

Services:

* Flask app → [http://localhost:5000](http://localhost:5000)
* Redis → Backend data store

---

## Final Outcome

* Push code → GitHub Actions triggers CI/CD pipeline.
* Docker image → Built and pushed to AWS ECR.
* Kubernetes manifests → Applied to EKS cluster.
* Application → Accessible via AWS LoadBalancer endpoint.
  

<img width="1919" height="962" alt="image" src="https://github.com/user-attachments/assets/ff375bb0-9a14-423f-9310-8acf748c608d" />


---

## Tech Stack

* **Flask** (Python web framework)
* **Redis** (in-memory database)
* **Docker** (containerization)
* **Kubernetes (EKS)** (orchestration)
* **GitHub Actions** (CI/CD)
* **AWS ECR** (image registry)

---

## 📜 License

This project is licensed under the MIT License.
