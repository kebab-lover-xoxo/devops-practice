Local minikube development

Quick deploy:

```bash
# make sure minikube is running
minikube start

# run the local deploy command
./k8s-fun/scripts/deploy-local.sh
```

Service is exposed locally via NodePort at 30080.
Access it with:

```bash
minikube -p minikube service node-api-service -n default --url
```

# access service
```bash
minikube service node-api-service -n default --url
curl "$(minikube service node-api-service -n default --url)/health"
curl "$(minikube service node-api-service -n default --url)/ready"
```

If pods don't become Ready, run:

```bash
kubectl describe pod -l app=node-api -n default
kubectl get events -n default --sort-by=.metadata.creationTimestamp | tail -n 50
kubectl logs pod/<pod-name> -c node-api-container -n default
```
