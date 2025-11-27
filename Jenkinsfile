pipeline {
    agent any
    
    environment {
        DOCKER_IMAGE = 'focusmate-app'
        DOCKER_TAG = "${BUILD_NUMBER}"
        DOCKER_REGISTRY = 'tanishullas04' // Your Docker Hub username
        FLUTTER_VERSION = '3.24.0'
    }
    
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out code...'
                checkout scm
            }
        }
        
        stage('Setup Flutter') {
            steps {
                script {
                    echo 'Setting up Flutter environment...'
                    sh '''
                        if [ ! -d "$HOME/flutter" ]; then
                            git clone https://github.com/flutter/flutter.git -b stable $HOME/flutter
                        fi
                        export PATH="$HOME/flutter/bin:$PATH"
                        flutter doctor -v
                        flutter config --enable-web
                    '''
                }
            }
        }
        
        stage('Install Dependencies') {
            steps {
                script {
                    echo 'Installing Flutter dependencies...'
                    sh '''
                        export PATH="$HOME/flutter/bin:$PATH"
                        flutter pub get
                    '''
                }
            }
        }
        
        stage('Run Tests') {
            steps {
                script {
                    echo 'Running tests...'
                    sh '''
                        export PATH="$HOME/flutter/bin:$PATH"
                        flutter test
                    '''
                }
            }
        }
        
        stage('Analyze Code') {
            steps {
                script {
                    echo 'Analyzing code...'
                    // Continue even if analysis finds issues (non-blocking warnings)
                    sh '''
                        export PATH="$HOME/flutter/bin:$PATH"
                        flutter analyze || true
                    '''
                }
            }
        }
        
        stage('Build Docker Image') {
            steps {
                script {
                    echo 'Building Docker image...'
                    sh """
                        docker build -t ${DOCKER_IMAGE}:${DOCKER_TAG} .
                        docker tag ${DOCKER_IMAGE}:${DOCKER_TAG} ${DOCKER_IMAGE}:latest
                    """
                }
            }
        }
        
        stage('Deploy Locally') {
            steps {
                script {
                    echo 'Deploying application locally...'
                    sh """
                        docker stop ${DOCKER_IMAGE} || true
                        docker rm ${DOCKER_IMAGE} || true
                        docker run -d --name ${DOCKER_IMAGE} -p 3000:80 ${DOCKER_IMAGE}:latest
                    """
                    echo 'Application deployed at http://localhost:3000'
                }
            }
        }
    }
    
    post {
        always {
            echo 'Cleaning up...'
            sh 'docker system prune -f'
        }
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
