# Start with Jenkins agent base image
FROM jenkins/agent:latest

# Install dependencies for Docker
USER root

RUN apt-get update && apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release \
    && mkdir -m 0755 -p /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null \
    && apt-get update \
    && apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create a directory for Docker data
RUN mkdir -p /var/lib/docker

# Configure Docker to run as a non-root user
RUN groupadd docker \
    && usermod -aG docker jenkins

# Ensure the Docker daemon starts when the container starts
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Set the right permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Define the entrypoint for the container
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# Switch back to jenkins user
USER jenkins
