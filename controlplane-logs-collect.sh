# Get all containers to see which ones are currently running vs crashed
sudo crictl ps -a

# Check kube-controller-manager logs
sudo crictl logs $(sudo crictl ps -a | grep kube-controller-manager | head -1 | awk '{print $1}') 2>&1 | tail -100

# Check kube-scheduler logs
sudo crictl logs $(sudo crictl ps -a | grep kube-scheduler | head -1 | awk '{print $1}') 2>&1 | tail -100

# Check API server logs to see if there's a connection issue
sudo crictl logs $(sudo crictl ps -a | grep kube-apiserver | head -1 | awk '{print $1}') 2>&1 | tail -50
