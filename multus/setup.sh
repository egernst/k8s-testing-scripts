
master=$(hostname)
sudo -E kubectl taint nodes "$master" node-role.kubernetes.io/master:NoSchedule-

sudo -E kubectl create -f crdnetwork.yaml
sudo -E kubectl create -f ngic-networks.yaml 
sudo -E kubectl create -f ubuntu-sriov-pod.yaml

