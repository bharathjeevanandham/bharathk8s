# Complete reset (run this first if you haven't already)
sudo systemctl stop kubelet
sudo kubeadm reset -f
sudo rm -rf /etc/kubernetes/
sudo rm -rf /var/lib/etcd/
sudo rm -rf /var/lib/kubelet/
sudo rm -rf $HOME/.kube/
sudo systemctl restart containerd

# Initialize with correct flags
sudo kubeadm init \
  --apiserver-advertise-address=192.168.2.100 \
  --pod-network-cidr=10.244.0.0/16 \
  --service-cidr=10.96.0.0/12

# Configure kubectl
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

# Wait for control plane to stabilize
echo "Waiting 60 seconds for control plane to start..."
sleep 60

# Check all control plane components
echo "=== Control plane containers ==="
sudo crictl ps | grep -E "(etcd|apiserver|controller|scheduler)"

# Check node status
echo -e "\n=== Node status ==="
kubectl get nodes

# Check all pods in kube-system
echo -e "\n=== Kube-system pods ==="
kubectl get pods -n kube-system
