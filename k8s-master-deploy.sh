#!/bin/bash
set -e

echo "==== Kubernetes Master Node Installation (Ubuntu 26.04 + v1.36) ===="

# 1. Disable swap (Required for Kubelet)
echo "[1/9] Disabling swap"
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# 2. Load Kernel Modules for Containerd & Networking
echo "[2/9] Loading kernel modules"
cat <<EOF >/etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# 3. Networking Sysctl Settings
echo "[3/9] Applying sysctl settings"
cat <<EOF >/etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

# 4. Install containerd.io (Docker Repo - Ubuntu Resolute)
echo "[4/9] Installing containerd.io"
apt-get update && apt-get install -y ca-certificates curl gnupg
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc

cat <<EOF >/etc/apt/sources.list.d/docker.sources
Types: deb
URIs: https://download.docker.com/linux/ubuntu
Suites: resolute
Components: stable
Architectures: $(dpkg --print-architecture)
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt-get update && apt-get install -y containerd.io

# 5. Configure Containerd with SystemdCgroup
echo "[5/9] Configuring containerd"
mkdir -p /etc/containerd
containerd config default >/etc/containerd/config.toml
sed -i 's/SystemdCgroup = false/SystemdCgroup = true/' /etc/containerd/config.toml
systemctl restart containerd

# 6. Install Kubernetes v1.36 Components
echo "[6/9] Installing K8s v1.36"
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.36/deb/Release.key \
 | gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg

cat <<EOF >/etc/apt/sources.list.d/kubernetes.sources
Types: deb
URIs: https://pkgs.k8s.io/core:/stable:/v1.36/deb/
Suites: /
Signed-By: /etc/apt/keyrings/kubernetes-apt-keyring.gpg
EOF

apt-get update
apt-get install -y kubelet kubeadm kubectl
apt-mark hold kubelet kubeadm kubectl

# 7. Initialize Cluster (Pod CIDR 10.244.0.0/16)
echo "[7/9] Initializing Cluster"
kubeadm init \
  --pod-network-cidr=10.244.0.0/16 \
  --cri-socket=unix:///run/containerd/containerd.sock

# 8. Setup Kubeconfig
echo "[8/9] Setting up kubectl"
USER_HOME=$(getent passwd ${SUDO_USER:-root} | cut -d: -f6)
mkdir -p "$USER_HOME/.kube"
cp /etc/kubernetes/admin.conf "$USER_HOME/.kube/config"
chown "$(id -u ${SUDO_USER:-root})":"$(id -g ${SUDO_USER:-root})" "$USER_HOME/.kube/config"

# 9. Install Calico CNI
echo "[9/9] Installing Calico"
export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "------------------------------------------------------------"
echo "Master node is READY. Taints are KEPT for workload security."
echo "Save the 'kubeadm join' command above to add your worker nodes later."
echo "------------------------------------------------------------"
