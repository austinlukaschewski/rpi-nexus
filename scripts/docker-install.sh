# Install docker on a RPi Ubuntu server

# Variables
KEYRING_FILE_PATH="/etc/apt/keyrings/docker.asc";
REMOVE_PACKAGE_LIST=("docker.io" "docker-doc" "docker-compose" "docker-compose-v2" "podman-docker" "containerd" "runc");
INSTALL_PACKAGE_LIST=("docker-ce" "docker-ce-cli" "containerd.io" "docker-buildx-plugin" "docker-compose-plugin");

# Check & uninstall packages related to docker
for pkg in "${REMOVE_PACKAGE_LIST[@]}"; do
    if dpkg -l | grep -q "^ii\s\+$pkg\s"; then
        echo "Removing package: $pkg"
        sudo apt-get remove -y "$pkg"
    else
        echo "Package $pkg is not installed, skipping."
    fi
done;

# Update & install ca-certificates and curl
sudo apt-get update;
sudo apt-get install -y ca-certificates curl;

# Setup keyring
sudo install -m 0755 -d /etc/apt/keyrings;
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o $KEYRING_FILE_PATH;
sudo chmod a+r $KEYRING_FILE_PATH;
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=$KEYRING_FILE_PATH] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null;
sudo apt-get update;

# Install docker and related packages
for pkg in "${INSTALL_PACKAGE_LIST[@]}"; do
    if ! dpkg -l | grep -q "^ii\s\+$pkg\s"; then
        echo "Installing package: $pkg"
        sudo apt-get install -y "$pkg"
    else
        echo "Package $pkg is already installed, skipping."
    fi
done;

# Setup docker group
sudo groupadd docker;
sudo usermod -aG docker $USER;
newgrp docker;

# OPTIONAL: Enable docker to start on boot
# sudo systemctl enable docker.service;
# sudo systemctl enable containerd.service;