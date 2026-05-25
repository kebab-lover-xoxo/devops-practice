#!/usr/bin/env bash
set -euo pipefail

# Run this one command from the repository root:
#   ./k8s-fun/scripts/deploy-local.sh
#
# Or from the k8s-fun directory:
#   ./scripts/deploy-local.sh
#
# Deploy local image into Minikube and restart Kubernetes deployment
# Usage: ./deploy-local.sh [--profile PROFILE] [--image IMAGE] [--namespace NAMESPACE]

APP_DIR="$(cd "$(dirname "$0")/.." && pwd)"
IMAGE_NAME=${IMAGE_NAME:-node-api:latest}
DEPLOYMENT=${DEPLOYMENT:-node-api}
NAMESPACE=${NAMESPACE:-default}
MINIKUBE_PROFILE=${MINIKUBE_PROFILE:-minikube}

print_usage() {
  cat <<EOF
Usage: $0 [--profile PROFILE] [--image IMAGE] [--namespace NAMESPACE]

Environment overrides: IMAGE_NAME, DEPLOYMENT, NAMESPACE, MINIKUBE_PROFILE

This script builds the image into Minikube (using 'minikube image build' when available),
restarts the deployment, and shows pod status.
EOF
}

while [[ ${1:-} != "" ]]; do
  case "$1" in
    --profile) MINIKUBE_PROFILE="$2"; shift 2;;
    --image) IMAGE_NAME="$2"; shift 2;;
    --namespace) NAMESPACE="$2"; shift 2;;
    -h|--help) print_usage; exit 0;;
    *) echo "Unknown arg: $1"; print_usage; exit 2;;
  esac
done

if ! command -v minikube >/dev/null 2>&1; then
  echo "minikube not found. Install minikube and try again." >&2
  exit 1
fi

if ! command -v kubectl >/dev/null 2>&1; then
  echo "kubectl not found. Install kubectl and configure access to the cluster." >&2
  exit 1
fi

echo "Using Minikube profile: $MINIKUBE_PROFILE"
if ! minikube status -p "$MINIKUBE_PROFILE" >/dev/null 2>&1; then
  echo "Minikube profile '$MINIKUBE_PROFILE' is not running. Starting..."
  minikube start -p "$MINIKUBE_PROFILE"
fi

kube() {
  minikube -p "$MINIKUBE_PROFILE" kubectl -- "$@"
}

echo "Using minikube kubectl via profile '$MINIKUBE_PROFILE'"

echo "Building image with 'minikube image build' -> $IMAGE_NAME"
(cd "$APP_DIR" && minikube image build -p "$MINIKUBE_PROFILE" -t "$IMAGE_NAME" -f Dockerfile .)

echo "Restarting deployment '$DEPLOYMENT' in namespace '$NAMESPACE'"
echo "Applying k8s manifests from $APP_DIR/k8s"
kube apply -f "$APP_DIR/k8s"

kube rollout restart deployment/"$DEPLOYMENT" -n "$NAMESPACE"

echo "Waiting for rollout to finish (120s timeout)"
kube rollout status deployment/"$DEPLOYMENT" -n "$NAMESPACE" --timeout=45s || echo "Rollout may still be in progress; check 'minikube -p "$MINIKUBE_PROFILE" kubectl -- get pods -n $NAMESPACE'"

kube get pods -n "$NAMESPACE"

echo "Service URL:"
minikube -p "$MINIKUBE_PROFILE" service node-api-service -n "$NAMESPACE" --url || true

echo "Done. If pods are stuck, run: kubectl describe pod -l app=node-api -n $NAMESPACE"