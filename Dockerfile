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

# Add Jenkins user to the docker group and grant necessary permissions
RUN groupadd -f docker && usermod -aG docker jenkins && \
    echo "jenkins ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# Start the Docker daemon in the background
RUN mkdir -p /var/run && touch /var/run/docker.sock

# Use tini as init system to handle PID 1 and signal forwarding
RUN apt-get install -y tini
ENTRYPOINT ["/usr/bin/tini", "--"]

# Start Docker daemon as part of the container startup
CMD ["sh", "-c", "dockerd & jenkins-agent"]
