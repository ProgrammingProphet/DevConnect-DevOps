#!/bin/bash

# Exit on any error
set -e

echo "Starting Terraform installation for Ubuntu (WSL)..."

# 1. Ensure system is up to date and required dependencies are installed
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl

# 2. Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | \
gpg --dearmor | \
sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg > /dev/null

# 3. Add HashiCorp Linux repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
sudo tee /etc/apt/sources.list.d/hashicorp.list

# 4. Update and install Terraform
sudo apt update
sudo apt-get install terraform -y

# 5. Verify installation
terraform --version

echo "Terraform installed successfully!"
