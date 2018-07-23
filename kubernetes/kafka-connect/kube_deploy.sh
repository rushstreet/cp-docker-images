kubectl config set-cluster "$KUBE_CLUSTER_NAME" --server="$KUBE_SERVER" --insecure-skip-tls-verify="true"
kubectl config set-credentials "$KUBE_CLUSTER_NAME" --token="$KUBE_TOKEN"
kubectl config set-context "$KUBE_CLUSTER_NAME" --cluster="$KUBE_CLUSTER_NAME" --user="$KUBE_CLUSTER_NAME"
kubectl config use-context "$KUBE_CLUSTER_NAME"
kubectl apply -f /tmp/deployment.yml