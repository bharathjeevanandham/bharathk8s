#stop the kubelet
systemctl stop kubelet

# Full reset
kubeadm reset -f

# Clean up
rm -rf /etc/kubernetes /var/lib/etcd /var/lib/kubelet ~/.kube
rm -rf /etc/cni/net.d

# Reinit - note the pod CIDR, adjust if yours is different
#kubeadm init --apiserver-advertise-address=192.168.2.100  --pod-network-cidr=10.244.0.0/16   --node-name=bharath-lab

kubeadm init  --apiserver-advertise-address=192.168.2.100   --pod-network-cidr=10.244.0.0/16   --service-cidr=10.96.0.0/12  --ignore-preflight-errors=all

# Restore kubeconfig
mkdir -p ~/.kube
cp /etc/kubernetes/admin.conf ~/.kube/config

