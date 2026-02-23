# Install Loki stack (includes Promtail for log collection)
helm install loki grafana/loki-stack \
  --namespace monitoring \
  --set grafana.enabled=false \
  --set loki.persistence.enabled=false \
  --set promtail.enabled=true

# Wait for Loki to be ready
kubectl wait --for=condition=ready pod -l app=loki -n monitoring --timeout=120s
