https://docs.aws.amazon.com/eks/latest/userguide/dashboard-tutorial.html

kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/v1.10.1/src/deploy/recommended/kubernetes-dashboard.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/influxdb.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/influxdb/heapster.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/heapster/master/deploy/kube-config/rbac/heapster-rbac.yaml

kubectl apply -f /vagrant/dashboard/influxdb.yaml
kubectl apply -f /vagrant/dashboard/heapster.yaml
kubectl apply -f /vagrant/dashboard/heapster-rbac.yaml
kubectl apply -f /vagrant/dashboard/kubernetes-dashboard.yaml
kubectl apply -f /vagrant/dashboard/dashboard-adminuser.yaml

# Bearer Token
kubectl -n kube-system describe secret $(kubectl -n kube-system get secret | grep admin-user | awk '{print $1}')