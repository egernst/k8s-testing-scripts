#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


#First Cleanup
export KUBECONFIG=/etc/kubernetes/admin.conf
sudo -E kubeadm reset
sudo systemctl stop kubelet
sudo systemctl stop docker
for c in `sudo crioctl ctr list | grep ^ID | cut -c5-`; do sudo crioctl ctr stop --id $c; sudo crioctl ctr remove --id $c ; done
for c in `sudo crioctl pod list | grep ^ID | cut -c5-`; do sudo crioctl pod stop --id $c; sudo crioctl pod remove --id $c ; done

sudo systemctl stop crio
sudo rm -rf /var/lib/cni/*
sudo rm -rf /var/run/crio/*
sudo rm -rf /var/log/crio/*
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf /run/flannel/*
sudo rm -rf /etc/cni/net.d/*

sudo umount /tmp/hyper/shared/pods/*/*/rootfs /tmp/tmp*/crio/overlay2/*/merged /tmp/hyper/shared/pods/*/*/rootfs /run/netns/cni-* /tmp/tmp*/crio-run/overlay2-containers/*/userdata/shm /tmp/tmp*/crio/overlay2 /tmp/hyper/shared/pods/*/*-resolv.conf
sudo umount /var/lib/containers/storage/overlay2
sudo rm -rf /var/lib/virtcontainers/pods/*
sudo rm -rf /var/run/virtcontainers/pods/*
sudo rm -rf /var/lib/containers/storage/*
sudo rm -rf /var/run/containers/storage/*


sudo ifconfig cni0 down
sudo ifconfig cbr0 down
sudo ifconfig flannel.1 down
sudo ifconfig docker0 down
sudo ip link del cni0
sudo ip link del cbr0
sudo ip link del flannel.1
sudo ip link del docker0


for c in `sudo runc list -q `; do sudo runc kill $c; sudo runc delete $c; done
for c in `sudo runc list -q `; do sudo cc-runtime kill $c; sudo cc-runtime delete $c; done

sudo journalctl --rotate
sudo journalctl --vacuum-time=1seconds

sudo systemctl daemon-reload
sudo systemctl start docker
sudo systemctl start crio
sudo systemctl start cc-proxy


sudo mkdir -p /var/lib/cni
sudo mkdir -p /var/run/crio
sudo mkdir -p /var/log/crio
sudo mkdir -p /var/lib/kubelet
sudo mkdir -p /run/flannel
sudo mkdir -p /etc/cni/net.d

sudo -E kubeadm init --pod-network-cidr 10.244.0.0/16

sudo -E kubectl create -f $DIR/kube-flannel-rbac.yml
sudo -E kubectl create --namespace kube-system -f $DIR/kube-flannel.yml

#Now run a test pod
master=$(hostname)

#Allow scheduling on master
sudo -E kubectl taint nodes $master node-role.kubernetes.io/master:NoSchedule-

sleep 15

sudo -E kubectl create -f $DIR/nginx-trusted.yaml
sudo -E kubectl create -f $DIR/nginx-untrusted.yaml

sudo -E kubectl get pods --all-namespaces -w
