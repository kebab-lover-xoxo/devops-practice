# Discover

Me fix cluster. Me find problem: pod need image `node-api:latest` but Minikube no have it.

## What was done and fixed

- Me look at `k8s/deployment.yaml`.
- Image was `node-api:latest` with `imagePullPolicy: Never`.
- App health endpoints were `/healthz` and `/readyz`, but probes used `/health` and `/ready`.
- That mean pods started then failed liveness/readiness checks.
- Me fix deployment probe paths and keep Minikube local image workflow simple.
- Me remove Makefile and extra fallback workarounds because the probe path was the major pain point.

## Local-first workflow

1. Build and load local image into Minikube.
2. Apply Kubernetes manifests.
3. Restart deployment.
4. Watch pods.

Local first means:

- Use local code and image first.
- Keep `node-api:latest` as the same name used in manifest.
- Use `minikube image build` when possible.
- If that fails, fall back to local `docker build` and `minikube image load`.
- Use `imagePullPolicy: Never` for local-only Minikube deployment.
- Make sure liveness/readiness probe paths match the app endpoints (`/healthz`, `/readyz`).

## Fallback framework

## Common Minikube commands

```bash
minikube status
minikube start
minikube stop
minikube delete
minikube image build -p minikube -t node-api:latest -f k8s-fun/Dockerfile k8s-fun
minikube image load node-api:latest
minikube service node-api-service -n default --url
```

Note: `node-api-service` is now a `NodePort` service on port `30080` for local Minikube development.

## Common kubectl commands

```bash
kubectl apply -f k8s-fun/k8s
kubectl rollout restart deployment/node-api -n default
kubectl rollout status deployment/node-api -n default
kubectl get pods -n default
kubectl describe pod -l app=node-api -n default
kubectl logs -l app=node-api -n default -f
kubectl port-forward svc/node-api-service 3000:3000 -n default
```

## Notes

- Local first is fastest for development.
- Fallback to registry when cluster node cannot access local image.
- If `imagePullPolicy: Never`, image must already exist on every node.
- If `imagePullPolicy: IfNotPresent`, cluster will use local image if it exists, otherwise try pull.
