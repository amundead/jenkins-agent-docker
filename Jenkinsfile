pipeline {
    agent {
        docker {
            image 'docker:latest'  // Use Docker image from your Docker cloud
            label 'cloud-agent-docker'       // Specify the Docker cloud label
            args '-v /var/run/docker.sock:/var/run/docker.sock'  // Mount Docker socket for Docker commands
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