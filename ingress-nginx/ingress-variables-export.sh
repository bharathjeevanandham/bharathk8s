export HTTP_NODE_PORT=30080
export HTTPS_NODE_PORT=30443
export NODE_IP="$(kubectl get nodes --output jsonpath="{.items[0].status.addresses[1].address}")"
