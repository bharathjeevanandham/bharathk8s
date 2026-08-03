#/bin/bash

#namespace creation
for ns in grafana promtheus headlamp harbor qualys nexus postgres neo4j kucero keycloak ingress-nginx;
do kubectl create ns $ns ;
done	


#helm install commands

helm install my-grafana grafana-community/grafana -n grafana
helm install prometheus prometheus-community/prometheus -n prometheus
helm install my-headlamp headlamp/headlamp --namespace headlamp
helm install my-release harbor/harbor --namespace harbor --set externalURL=https://homelab.dev --set expose.ingress.hosts.core=://homelab.dev
#helm install qualys-tc qualys-helm-chart/qualys-tc --namespace qualys --set global.customerId=<YOUR_CUSTOMER_ID> --set global.activationId=<YOUR_ACTIVATION_ID>   --set global.gatewayUrl=<YOUR_POD_URL>
helm install nexus-repo sonatype/nexus-repository-manager -n nexus
helm install postgres bitnami/postgresql -n postgres
helm install my-ingress ingress-nginx/ingress-nginx --namespace ingress-nginx

