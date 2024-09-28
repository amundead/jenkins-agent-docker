pipeline {
    agent {
        label 'my-docker-template'  // Use the Docker template label
    }

    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker-hub-credentials')  // Jenkins credential ID for Docker Hub
        DOCKERHUB_USERNAME = 'your-dockerhub-username'  // Your Docker Hub username
        IMAGE_NAME = "${DOCKERHUB_USERNAME}/your-image-name"  // Docker Hub image name
        TAG = 'latest'  // Tag for the Docker image
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your repository
                git branch: 'main', url: 'https://github.com/your-repo-url.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image
                    sh "docker build -t ${IMAGE_NAME}:${TAG} ."
                }
            }
        }

        stage('Push Docker Image to Docker Hub') {
            steps {
                script {
                    // Log in to Docker Hub
                    sh "docker login -u ${DOCKERHUB_CREDENTIALS_USR} -p ${DOCKERHUB_CREDENTIALS_PSW}"
                    // Push Docker image to Docker Hub
                    sh "docker push ${IMAGE_NAME}:${TAG}"
                }
            }
        }

        stage('Clean up') {
            steps {
                script {
                    // Remove unused Docker images to free up space
                    sh "docker rmi ${IMAGE_NAME}:${TAG}"
                }
            }
        }
    }

    post {
        always {
            // Clean up workspace after the pipeline
            cleanWs()
        }
    }
}