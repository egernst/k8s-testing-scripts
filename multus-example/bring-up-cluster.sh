sudo cp 01-multus-cni.conf /etc/cni/net.d/
sudo -E kubeadm init --pod-network-cidr 10.244.0.0/16
export KUBECONFIG=/etc/kubernetes/admin.conf
sudo -E kubectl get pods --all-namespaces -w -o wide
