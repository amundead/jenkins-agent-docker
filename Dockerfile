# Use the official Jenkins inbound agent as the base image
FROM jenkins/inbound-agent:latest

# Switch to root user to install Docker
USER root

# Install Docker Engine on Debian 12 (Bookworm)
RUN apt-get update && \
    apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg && \
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Create the docker group if it doesn't exist and add the jenkins user to it
RUN groupadd -f docker && usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Working directory for Jenkins agent
WORKDIR /home/jenkins/agent

# Default entrypoint for Jenkins inbound agent
ENTRYPOINT ["jenkins-agent"]
