$ echo "deploying neo4j db in Bharath homelab k8s cluster at $(date)"
deploying neo4j db in Bharath homelab k8s cluster at Sat May 16 20:29:59 UTC 2026
$ helm install my-neo4j neo4j/neo4j -f values.yaml -n $NAMESPACE
NAME: my-neo4j
LAST DEPLOYED: Sat May 16 20:30:00 2026
NAMESPACE: neo4j
STATUS: deployed
REVISION: 1
DESCRIPTION: Install complete
TEST SUITE: None
NOTES:
Thank you for installing neo4j.
Your release "my-neo4j" has been installed  in namespace "neo4j".
The neo4j user's password has been set to "bjl2eGeeD03jIa".To view the progress of the rollout try:
  $ kubectl --namespace "neo4j" rollout status --watch --timeout=600s statefulset/my-neo4j
Once rollout is complete you can log in to Neo4j at "neo4j://my-neo4j.neo4j.svc.cluster.local:7687". Try:
  $ kubectl run --rm -it --namespace "neo4j" --image "neo4j:2026.04.0" cypher-shell \
     -- cypher-shell -a "neo4j://my-neo4j.neo4j.svc.cluster.local:7687" -u neo4j -p "bjl2eGeeD03jIa"
Graphs are everywhere!
WARNING: Passwords set using 'neo4j.password' will be stored in plain text in the Helm release ConfigMap.
Please consider using 'neo4j.passwordFromSecret' for improved security.
$ kubectl get po -n $NAMESPACE
NAME                          READY   STATUS      RESTARTS   AGE
my-neo4j-0                    0/1     Pending     0          0s
neo4j-backup-29649225-fnpr7   0/1     Completed   0          165m
Cleaning up project directory and file based variables
