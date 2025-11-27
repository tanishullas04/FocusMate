# FocusMate - Deployment Guide

This guide covers Docker containerization and Jenkins CI/CD setup for the FocusMate Flutter application.

## Table of Contents
1. [Docker Setup](#docker-setup)
2. [Jenkins Setup](#jenkins-setup)
3. [Running Locally](#running-locally)
4. [Deployment](#deployment)

---

## Docker Setup

### Prerequisites
- Docker Desktop installed ([Download here](https://www.docker.com/products/docker-desktop))
- Docker Compose installed (included with Docker Desktop)

### Docker Files Overview

- **Dockerfile**: Multi-stage build for optimized Flutter web app
- **docker-compose.yml**: Orchestrates the application container
- **nginx.conf**: Nginx configuration for serving the Flutter web app
- **.dockerignore**: Excludes unnecessary files from Docker build

### Building the Docker Image

```bash
# Build the image
docker build -t focusmate-app:latest .

# Or use Docker Compose
docker-compose build
```

### Running with Docker

```bash
# Using Docker directly
docker run -d -p 3000:80 --name focusmate focusmate-app:latest

# Using Docker Compose (recommended)
docker-compose up -d
```

Access the application at: http://localhost:3000

**Note:** Port 3000 is used to avoid conflict with Jenkins (which runs on 8080)

### Docker Commands Reference

```bash
# View running containers
docker ps

# View logs
docker logs focusmate-app
docker-compose logs -f

# Stop the application
docker stop focusmate-app
docker-compose down

# Rebuild after code changes
docker-compose up -d --build

# Remove all containers and images
docker-compose down --rmi all
```

---

## Jenkins Setup

### Prerequisites
- Jenkins installed ([Installation Guide](https://www.jenkins.io/doc/book/installing/))
- Docker plugin for Jenkins
- Git plugin for Jenkins

### Step 1: Install Jenkins

#### macOS (using Homebrew)
```bash
# Install Jenkins
brew install jenkins-lts

# Start Jenkins
brew services start jenkins-lts

# Jenkins will be available at: http://localhost:8080
```

#### Using Docker
```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

**Note:** Jenkins uses port 8080, so the FocusMate app is configured to run on port 3000

### Step 2: Initial Jenkins Configuration

1. **Get initial admin password:**
   ```bash
   # macOS
   cat /Users/Shared/Jenkins/Home/secrets/initialAdminPassword
   
   # Docker
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```

2. **Access Jenkins:** http://localhost:8080

3. **Install suggested plugins**

4. **Create admin user**

### Step 3: Install Required Plugins

1. Go to **Manage Jenkins** → **Manage Plugins** → **Available plugins**
2. Search for and install the following plugins:
   - **Docker Pipeline** (or "Docker" plugin)
   - **Git plugin** (usually pre-installed)
   - **GitHub Integration** (if using GitHub)
   - **Pipeline** (usually pre-installed)
   - **Credentials** and **Credentials Binding** (usually pre-installed)
   
3. If you can't find "Credentials Binding Plugin", check **Installed plugins** - it's likely already installed
4. Click **Install** and restart Jenkins if prompted

### Step 4: Configure Jenkins

#### Add Docker Credentials (if pushing to registry)

1. Go to **Manage Jenkins** → **Manage Credentials**
2. Add credentials:
   - ID: `docker-registry-credentials`
   - Username: Your Docker Hub username
   - Password: Your Docker Hub password/token

#### Configure Flutter on Jenkins Server

```bash
# SSH into Jenkins server or run locally where Jenkins is installed
cd /opt
sudo git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:/opt/flutter/bin"
flutter doctor
```

Add Flutter to Jenkins PATH:
1. Go to **Manage Jenkins** → **Configure System**
2. Find **Global properties** → Check **Environment variables**
3. Add: `PATH+EXTRA=/opt/flutter/bin`

### Step 5: Create Jenkins Pipeline Job

1. Click **New Item**
2. Enter name: `FocusMate-Pipeline`
3. Select **Pipeline**
4. Click **OK**

#### Configure the Pipeline

**General:**
- Description: "FocusMate Flutter App CI/CD Pipeline"
- GitHub project (optional): https://github.com/tanishullas04/FocusMate

**Build Triggers:**
- ✓ GitHub hook trigger for GITScm polling (for automatic builds)
- ✓ Poll SCM: `H/5 * * * *` (check every 5 minutes)

**Pipeline:**
- Definition: **Pipeline script from SCM**
- SCM: **Git**
- Repository URL: `https://github.com/tanishullas04/FocusMate.git`
- Branch: `*/devTanish` (or your main branch)
- Script Path: `Jenkinsfile`

### Step 6: Configure Webhooks (Optional - for auto-trigger)

#### GitHub Webhook Setup

1. Go to your GitHub repository
2. Settings → Webhooks → Add webhook
3. Payload URL: `http://YOUR_JENKINS_URL/github-webhook/`
4. Content type: `application/json`
5. Events: **Just the push event**

---

## Running Locally

### Development Mode

```bash
# Run Flutter app locally
flutter run -d chrome

# Or specify web server port
flutter run -d web-server --web-port=3000
```

### Docker Development Mode

```bash
# Build and run with Docker Compose
docker-compose up --build

# Run in background
docker-compose up -d

# View logs
docker-compose logs -f
```

---

## Deployment

### Manual Deployment Steps

1. **Build the Docker image:**
   ```bash
   docker build -t focusmate-app:v1.0.0 .
   ```

2. **Tag for registry:**
   ```bash
   docker tag focusmate-app:v1.0.0 your-registry/focusmate-app:v1.0.0
   ```

3. **Push to registry:**
   ```bash
   docker push your-registry/focusmate-app:v1.0.0
   ```

4. **Deploy on server:**
   ```bash
   docker pull your-registry/focusmate-app:v1.0.0
   docker run -d -p 80:80 --name focusmate your-registry/focusmate-app:v1.0.0
   ```

### Automated Deployment with Jenkins

The Jenkinsfile handles:
- ✓ Code checkout
- ✓ Flutter setup
- ✓ Dependency installation
- ✓ Running tests
- ✓ Code analysis
- ✓ Docker image build
- ✓ Push to registry (on main branch)
- ✓ Deployment (on main branch)

**To trigger deployment:**
1. Push code to `main` branch
2. Jenkins automatically builds and deploys
3. Monitor in Jenkins dashboard

---

## Environment Variables

### Firebase Configuration

Ensure your Firebase configuration files are present:
- `android/app/google-services.json`
- `ios/Runner/GoogleService-Info.plist`
- `lib/firebase_options.dart`

**Note:** These files are in `.gitignore`. For production:
1. Use Jenkins credentials/secrets
2. Or use Docker build arguments
3. Or use environment-specific configs

### Example: Using Build Arguments

```dockerfile
# In Dockerfile
ARG FIREBASE_CONFIG
ENV FIREBASE_CONFIG=${FIREBASE_CONFIG}
```

```bash
# Build command
docker build --build-arg FIREBASE_CONFIG="your-config" -t focusmate-app .
```

---

## Troubleshooting

### Docker Issues

**Issue:** Build fails at Flutter step
```bash
# Clear Docker cache
docker builder prune -a
docker build --no-cache -t focusmate-app .
```

**Issue:** Port already in use
```bash
# Check what's using the port
lsof -ti:8080 | xargs kill -9

# Or use different port
docker run -p 3000:80 focusmate-app
```

### Jenkins Issues

**Issue:** Flutter not found
- Ensure Flutter is installed on Jenkins server
- Check PATH configuration in Jenkins

**Issue:** Docker not available in Jenkins
```bash
# Add Jenkins user to docker group
sudo usermod -aG docker jenkins
sudo systemctl restart jenkins
```

**Issue:** Permission denied for Docker socket
```bash
sudo chmod 666 /var/run/docker.sock
```

---

## Production Checklist

- [ ] Update `DOCKER_REGISTRY` in Jenkinsfile
- [ ] Add Docker registry credentials in Jenkins
- [ ] Configure SSL/HTTPS in Nginx
- [ ] Set up proper Firebase security rules
- [ ] Configure environment variables
- [ ] Set up monitoring and logging
- [ ] Configure backup strategy
- [ ] Test rollback procedures
- [ ] Set up domain and DNS
- [ ] Configure firewall rules

---

## Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Docker Documentation](https://docs.docker.com/)
- [Jenkins Documentation](https://www.jenkins.io/doc/)
- [Nginx Documentation](https://nginx.org/en/docs/)

---

## Support

For issues or questions:
- GitHub Issues: https://github.com/tanishullas04/FocusMate/issues
- Email: your-email@example.com

---

**Last Updated:** November 27, 2025
