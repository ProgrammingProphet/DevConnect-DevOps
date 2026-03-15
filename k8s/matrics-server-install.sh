#install metrics server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

#check if metrics server is installed
kubectl get pods -n kube-system | grep metrics-server

#check if metrics server is working
kubectl top nodes
kubectl top pods -n devconnect