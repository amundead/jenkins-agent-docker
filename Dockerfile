# Start from the Jenkins agent base image
FROM jenkins/agent:latest

# Switch to root user to install Docker
USER root

# Install Docker engine on Debian Bookworm 12
RUN apt-get update \
    apt-get install ca-certificates curl \
    install -m 0755 -d /etc/apt/keyrings \
    curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.ascupg \
    chmod a+r /etc/apt/keyrings/docker.asc \
    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "bookworm") stable" | \
    tee /etc/apt/sources.list.d/docker.list > /dev/null \
    apt-get update \
    apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
# Add the Jenkins user to the Docker group
RUN groupadd -f docker && usermod -aG docker jenkins

# Use CMD to start the Docker daemon and Jenkins agent
CMD ["sh", "-c", "dockerd & jenkins-agent"]