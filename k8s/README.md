# FocusMate Kubernetes Setup Guide

This guide covers deploying the FocusMate application to Kubernetes.

## Prerequisites

- **Kubernetes cluster** (minikube, Docker Desktop, GKE, EKS, or AKS)
- **kubectl** installed and configured
- **Docker image** pushed to registry (tanishullas04/focusmate-app)

## Quick Start

### 1. Install kubectl

#### macOS
```bash
brew install kubectl
```

#### Verify installation
```bash
kubectl version --client
```

### 2. Set up local Kubernetes (choose one)

#### Option A: Docker Desktop (Recommended for Mac)
1. Open Docker Desktop
2. Go to Settings → Kubernetes
3. Check "Enable Kubernetes"
4. Click "Apply & Restart"

#### Option B: Minikube
```bash
# Install minikube
brew install minikube

# Start minikube
minikube start --driver=docker

# Enable ingress addon
minikube addons enable ingress
```

### 3. Deploy to Kubernetes

```bash
# Navigate to project directory
cd /Users/tanishullas/Desktop/FocusMate

# Apply all Kubernetes manifests
kubectl apply -f k8s/

# Or apply individually
kubectl apply -f k8s/configmap.yaml
kubectl apply -f k8s/deployment.yaml
kubectl apply -f k8s/service.yaml
kubectl apply -f k8s/hpa.yaml
kubectl apply -f k8s/ingress.yaml
```

### 4. Verify Deployment

```bash
# Check deployments
kubectl get deployments

# Check pods
kubectl get pods

# Check services
kubectl get services

# Check ingress
kubectl get ingress

# View detailed pod status
kubectl describe pod <pod-name>

# View logs
kubectl logs -f <pod-name>
```

### 5. Access the Application

#### Using LoadBalancer (Docker Desktop)
```bash
# Get the external IP
kubectl get service focusmate-service

# Access at the EXTERNAL-IP
# Usually: http://localhost
```

#### Using Minikube
```bash
# Get the URL
minikube service focusmate-service --url

# Or use port forwarding
kubectl port-forward service/focusmate-service 3000:80

# Access at: http://localhost:3000
```

## Kubernetes Manifests Overview

### deployment.yaml
- **Replicas**: 3 pods for high availability
- **Resources**: CPU and memory limits
- **Health checks**: Liveness and readiness probes
- **Image**: tanishullas04/focusmate-app:latest

### service.yaml
- **Type**: LoadBalancer
- **Port**: 80 (HTTP)
- Exposes the deployment to external traffic

### ingress.yaml
- **Domain**: focusmate.yourdomain.com (update this!)
- **TLS**: SSL certificate support
- **Nginx**: Ingress controller

### configmap.yaml
- Environment configuration
- Application settings

### hpa.yaml
- **Auto-scaling**: 2-10 replicas
- **CPU threshold**: 70%
- **Memory threshold**: 80%

## Common Commands

### Deployment Management

```bash
# Scale deployment
kubectl scale deployment focusmate-app --replicas=5

# Update image
kubectl set image deployment/focusmate-app focusmate-app=tanishullas04/focusmate-app:v2

# Rollback deployment
kubectl rollout undo deployment/focusmate-app

# Check rollout status
kubectl rollout status deployment/focusmate-app

# View rollout history
kubectl rollout history deployment/focusmate-app
```

### Debugging

```bash
# Get pod logs
kubectl logs <pod-name>

# Follow logs in real-time
kubectl logs -f <pod-name>

# Execute command in pod
kubectl exec -it <pod-name> -- /bin/sh

# Describe pod (detailed info)
kubectl describe pod <pod-name>

# Get events
kubectl get events --sort-by=.metadata.creationTimestamp
```

### Resource Management

```bash
# View resource usage
kubectl top nodes
kubectl top pods

# Delete resources
kubectl delete -f k8s/

# Or delete individually
kubectl delete deployment focusmate-app
kubectl delete service focusmate-service
kubectl delete ingress focusmate-ingress
```

## Production Deployment

### 1. Update Image in deployment.yaml

Change the image tag from `latest` to a specific version:

```yaml
image: tanishullas04/focusmate-app:v1.0.0
```

### 2. Update Ingress Domain

Edit `k8s/ingress.yaml` and replace `focusmate.yourdomain.com` with your actual domain.

### 3. Set up TLS/SSL

#### Install cert-manager
```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.0/cert-manager.yaml
```

#### Create ClusterIssuer
```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: your-email@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

### 4. Configure Environment Variables

Update `k8s/configmap.yaml` with your configuration:

```yaml
data:
  FIREBASE_API_KEY: "your-api-key"
  FIREBASE_PROJECT_ID: "your-project-id"
```

### 5. Use Secrets for Sensitive Data

```bash
# Create secret
kubectl create secret generic firebase-secret \
  --from-literal=api-key=your-api-key \
  --from-literal=auth-domain=your-auth-domain

# Use in deployment
# Add to deployment.yaml under containers:
envFrom:
  - secretRef:
      name: firebase-secret
```

## Cloud Provider Setup

### Google Kubernetes Engine (GKE)

```bash
# Install gcloud CLI
brew install google-cloud-sdk

# Login
gcloud auth login

# Create cluster
gcloud container clusters create focusmate-cluster \
  --num-nodes=3 \
  --zone=us-central1-a

# Get credentials
gcloud container clusters get-credentials focusmate-cluster --zone=us-central1-a

# Deploy
kubectl apply -f k8s/
```

### Amazon EKS

```bash
# Install eksctl
brew tap weaveworks/tap
brew install eksctl

# Create cluster
eksctl create cluster \
  --name focusmate-cluster \
  --region us-west-2 \
  --nodegroup-name standard-workers \
  --nodes 3

# Deploy
kubectl apply -f k8s/
```

### Azure AKS

```bash
# Install Azure CLI
brew install azure-cli

# Login
az login

# Create cluster
az aks create \
  --resource-group focusmate-rg \
  --name focusmate-cluster \
  --node-count 3 \
  --enable-addons monitoring

# Get credentials
az aks get-credentials --resource-group focusmate-rg --name focusmate-cluster

# Deploy
kubectl apply -f k8s/
```

## CI/CD Integration with Jenkins

Add this stage to your Jenkinsfile:

```groovy
stage('Deploy to Kubernetes') {
    when {
        branch 'main'
    }
    steps {
        script {
            echo 'Deploying to Kubernetes...'
            sh '''
                kubectl set image deployment/focusmate-app \
                  focusmate-app=${DOCKER_REGISTRY}/${DOCKER_IMAGE}:${DOCKER_TAG}
                
                kubectl rollout status deployment/focusmate-app
            '''
        }
    }
}
```

## Monitoring

### Install Prometheus & Grafana

```bash
# Add Helm repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

# Install Prometheus
helm install prometheus prometheus-community/kube-prometheus-stack

# Access Grafana
kubectl port-forward svc/prometheus-grafana 3000:80

# Default credentials: admin / prom-operator
```

## Troubleshooting

### Pods not starting

```bash
# Check pod status
kubectl get pods

# View pod details
kubectl describe pod <pod-name>

# Check logs
kubectl logs <pod-name>
```

### Service not accessible

```bash
# Check service
kubectl get svc focusmate-service

# Check endpoints
kubectl get endpoints focusmate-service

# Test from within cluster
kubectl run -it --rm debug --image=busybox --restart=Never -- wget -O- http://focusmate-service
```

### Image pull errors

```bash
# Create docker registry secret
kubectl create secret docker-registry regcred \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=tanishullas04 \
  --docker-password=<your-password> \
  --docker-email=<your-email>

# Add to deployment.yaml
spec:
  imagePullSecrets:
  - name: regcred
```

## Best Practices

1. **Use specific image tags** instead of `latest`
2. **Set resource limits** for all containers
3. **Use namespaces** for environment separation
4. **Implement health checks** (liveness/readiness probes)
5. **Use ConfigMaps and Secrets** for configuration
6. **Enable autoscaling** (HPA)
7. **Set up monitoring** (Prometheus/Grafana)
8. **Implement logging** (ELK stack or cloud-native solutions)
9. **Use RBAC** for access control
10. **Regular backups** of cluster state

## Cleanup

```bash
# Delete all resources
kubectl delete -f k8s/

# Stop minikube (if using)
minikube stop

# Delete minikube cluster
minikube delete
```

---

**Last Updated:** November 28, 2025
