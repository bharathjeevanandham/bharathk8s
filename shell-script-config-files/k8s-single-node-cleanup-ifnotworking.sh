sudo rm -rf /etc/cni/net.d ; sudo rm -rf /var/lib/cni; sudo rm -rf /var/lib/kubelet/*; sudo rm -rf /etc/kubernetes

sudo systemctl restart containerd; sudo systemctl restart kubelet

kubeadm init --apiserver-advertise-address=192.168.1.7 --pod-network-cidr=192.168.0.0/16
