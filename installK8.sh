#!/bin/bash

# # Install Homebrew if not installed
# if ! command -v brew &>/dev/null; then
#     echo "Homebrew not found. Installing Homebrew..."
#     /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi

# # Update Homebrew
# brew update

# # Install kubectl
# brew install kubectl

# # Install minikube (for local Kubernetes cluster)
# brew install minikube

# # Start minikube with Apple Silicon support
# minikube start --driver=qemu --container-runtime=containerd

# echo "Kubernetes (kubectl + minikube) installation complete."
# echo "You can now use 'kubectl' and 'minikube' commands."

# Install Kubernetes (kubeadm, kubelet, kubectl) using curl (for Linux systems)
# Note: This section is not typically used on macOS, but provided for reference.

# Download latest release of kubectl
# curl -LO "https://dl.k8s.io/release/$(curl -Ls https://dl.k8s.io/release/stable.txt)/bin/$(uname | tr '[:upper:]' '[:lower:]')/amd64/kubectl"
echo "Installing kubectl via curl for macOS (darwin/arm64)..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl"

# validate the binary before install
echo "Validating  kubectl binary against the checksum file..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/arm64/kubectl.sha256"

if echo "$(cat kubectl.sha256)  kubectl" | shasum -a 256 --check --status; then
    echo "OK"
else
    echo "ERROR"
    exit 1
fi  
chmod +x kubectl
sudo mv kubectl /usr/local/bin/

echo "kubectl installed via curl."

# Vérifier que /usr/local/bin est dans le PATH
if [[ ":$PATH:" != *":/usr/local/bin:"* ]]; then
    echo "/usr/local/bin n'est pas dans le PATH !"
    # Ajouter /usr/local/bin au PATH
    echo "Ajout de /usr/local/bin au PATH..."
    echo 'export PATH="/usr/local/bin:$PATH"' >> ~/.bash_profile
    source ~/.bash_profile
    echo "/usr/local/bin a été ajouté au PATH."
else
    echo "/usr/local/bin est bien dans le PATH."
fi
   