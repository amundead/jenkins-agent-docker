# Use the official Jenkins inbound agent as the base image
FROM jenkins/inbound-agent:latest

# Switch to root user to install Docker
USER root

# Install Docker Engine on Debian 12 (Bookworm)
RUN apt-get update \
    apt-get install ca-certificates curl \
    install -m 0755 -d /etc/apt/keyrings \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    chmod a+r /etc/apt/keyrings/docker.asc \
    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \ 
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    apt-get update \
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the Jenkins user to the Docker group so it can run Docker commands
RUN usermod -aG docker jenkins

# Switch back to Jenkins user
USER jenkins

# Working directory for Jenkins agent
WORKDIR /home/jenkins/agent

# Default entrypoint for Jenkins inbound agent
ENTRYPOINT ["jenkins-agent"]
