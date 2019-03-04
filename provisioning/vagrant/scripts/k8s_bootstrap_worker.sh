#!/bin/bash

# Join worker nodes to the Kubernetes cluster
echo "[TASK 1] Join node to Kubernetes Cluster"
yum install -q -y sshpass >/dev/null 2>&1
#echo "$1"
#copy_joincluster_cmd="sshpass -p 'kubeadmin' scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no kmaster.local:/joincluster.sh /joincluster.sh 2>/dev/null"
#echo "Executing command: $copy_joincluster_cmd"
#eval "$copy_joincluster_cmd"
sshpass -p "kubeadmin" scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$1":/joincluster.sh /joincluster.sh
bash /joincluster.sh >/dev/null 2>&1
