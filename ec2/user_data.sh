#!/bin/bash
exec > >(tee /var/log/user-data.log | logger -t user-data) 2>&1
set -euo pipefail

echo "=== Starting user data script ==="

# Update system packages
# --allowerasing handles the curl-minimal vs curl conflict on AL2023
echo "--- Updating system packages ---"
dnf update -y --allowerasing

# Install essential utilities
# Note: curl is already available via curl-minimal on AL2023
echo "--- Installing utilities ---"
dnf install -y \
  git \
  wget \
  unzip \
  tar \
  lsof \
  htop \
  vim

# Install Docker
echo "--- Installing Docker ---"
dnf install -y docker

# Enable and start Docker service
systemctl enable docker
systemctl start docker

# Add ec2-user to the docker group (no sudo needed for docker commands)
usermod -aG docker ec2-user

# Install Docker Compose v2 plugin (pinned stable version)
echo "--- Installing Docker Compose ---"
DOCKER_COMPOSE_VERSION="v2.35.0"
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-linux-x86_64" \
  -o /usr/local/lib/docker/cli-plugins/docker-compose
chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

# Symlink for standalone `docker-compose` command
ln -sf /usr/local/lib/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose

# Verify installations
echo "--- Git version ---"
git --version

echo "--- Docker version ---"
docker --version

echo "--- Docker Compose version ---"
docker compose version

echo "=== User data script completed successfully ==="
