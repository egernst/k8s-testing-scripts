
master=$(hostname)
sudo -E kubectl taint nodes "$master" node-role.kubernetes.io/master:NoSchedule-

#create custom resource defined network:
sudo -E kubectl create -f crd-network.yaml

#create a few sample networks
sudo -E kubectl create -f networks.yaml 

#launch multihomed pod
sudo -E kubectl create -f ubuntu-sriov-pod.yaml

