# Add Prometheus community repo
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Add Grafana repo
helm repo add grafana https://grafana.github.io/helm-charts

# Update repos
helm repo update

# Verify repos
helm repo list
