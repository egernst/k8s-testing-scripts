sudo cp 01-multus-cni.conf /etc/cni/net.d/
sudo -E kubeadm init --pod-network-cidr 10.244.0.0/16
export KUBECONFIG=/etc/kubernetes/admin.conf
sudo -E kubectl create -f "../k8s/kube-flannel-rbac.yml"
sudo -E kubectl create --namespace kube-system -f "../k8s/kube-flannel.yml"
master=$(hostname)
sudo -E kubectl taint nodes "$master" node-role.kubernetes.io/master:NoSchedule-
sudo -E kubectl get pods --all-namespaces -w
