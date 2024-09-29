pipeline {
    agent {
        docker {
            image 'jenkins/agent:latest' // The Docker image to use for the agent
            label 'docker-cloud-template' // Label for the Docker Cloud agent
            dockerHost 'tcp://172.26.16.55:2375' // Docker host connection
            args '-v /var/run/docker.sock:/var/run/docker.sock' // Pass Docker socket if needed
        }
    }

    environment {
        GITHUB_CREDENTIALS = credentials('github-credentials-id')  // Jenkins credential ID for GitHub credentials (username/token)
        GITHUB_OWNER = 'amundead'  // Your GitHub username or organization
        GITHUB_REPOSITORY = 'jenkins-agent-docker'  // The repository where the package will be hosted
        IMAGE_NAME = "ghcr.io/${GITHUB_OWNER}/${GITHUB_REPOSITORY}"  // Full image name for GitHub Packages
        TAG = '1.03'  // Tag for the Docker image
    }

    stages {
        stage('Checkout') {
            steps {
                // Checkout the source code from your repository
                git branch: 'main', url: "https://github.com/${GITHUB_OWNER}/${GITHUB_REPOSITORY}.git"
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    // Build Docker image using docker.build
                    docker.build("${IMAGE_NAME}:${TAG}")
                }
            }
        }

        stage('Push Docker Image to GitHub Packages') {
            steps {
                script {
                    // Log in to GitHub Packages using password stdin for security
                    sh "echo ${GITHUB_CREDENTIALS_PSW} | docker login ghcr.io -u ${GITHUB_CREDENTIALS_USR} --password-stdin"
                    // Push Docker image to GitHub Packages
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