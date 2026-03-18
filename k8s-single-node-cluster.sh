#!/bin/bash
#2026-03-16

set -e

date
echo "Disabling swap (required for Kubernetes)..."
swapoff -a
sed -i '/ swap / s/^/#/' /etc/fstab

echo "Loading kernel modules..."
cat <<EOF | tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

echo "Applying sysctl settings..."
cat <<EOF | tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

echo "Initializing Kubernetes cluster..."
kubeadm init --pod-network-cidr=192.168.0.0/16

echo "Configuring kubectl for current user..."
mkdir -p $HOME/.kube
cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
chown $(id -u):$(id -g) $HOME/.kube/config

echo "Installing Calico CNI..."
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml

echo "Allowing control-plane node to schedule pods..."
kubectl taint nodes --all node-role.kubernetes.io/control-plane- || true

echo "Waiting for node to become ready..."
sleep 20
kubectl get nodes

echo "Cluster setup complete."
date

