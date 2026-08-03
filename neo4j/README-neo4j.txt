root@unicorn:~/bharathk8s/neo4j# helm install my-neo4j neo4j/neo4j -n neo4j -f values.yaml
NAME: my-neo4j
LAST DEPLOYED: Fri Jul  3 11:09:17 2026
NAMESPACE: neo4j
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
Thank you for installing neo4j.

Your release "my-neo4j" has been installed  in namespace "neo4j".

The neo4j user's password has been set to "l52WZvA9OxlXVV".To view the progress of the rollout try:

  $ kubectl --namespace "neo4j" rollout status --watch --timeout=600s statefulset/my-neo4j

Once rollout is complete you can log in to Neo4j at "neo4j://my-neo4j.neo4j.svc.cluster.local:7687". Try:

  $ kubectl run --rm -it --namespace "neo4j" --image "neo4j:2026.05.0" cypher-shell \
     -- cypher-shell -a "neo4j://my-neo4j.neo4j.svc.cluster.local:7687" -u neo4j -p "l52WZvA9OxlXVV"

Graphs are everywhere!

WARNING: Passwords set using 'neo4j.password' will be stored in plain text in the Helm release ConfigMap.
Please consider using 'neo4j.passwordFromSecret' for improved security.
root@unicorn:~/bharathk8s/neo4j#

