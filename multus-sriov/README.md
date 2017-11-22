# Bring up cluster

We assume that k8s is cleaned up and not running on the system (ie, you have run
kubeadm reset if something was up prior).  

User can run ``` ./bring-up-cluster.sh``` -- we describe what is done below:

First, the script manually copies the cni config to /etc/cni/net.d,
then brings up the cluster via kubeadm.  Once up, we start up flannel,
which is the default network configured with this multus setup.  We then
sit and wait for all of the pods to come up.  ctl-c to stop watching the pods come up...

Once ready, you should see the following:
```
$ sudo -E kubectl get pods --all-namespaces
NAMESPACE     NAME                              READY     STATUS    RESTARTS   AGE
kube-system   etcd-sriov-1                      1/1       Running   0          3m
kube-system   kube-apiserver-sriov-1            1/1       Running   0          3m
kube-system   kube-controller-manager-sriov-1   1/1       Running   0          3m
kube-system   kube-dns-545bc4bfd4-qglbf         3/3       Running   0          4m
kube-system   kube-flannel-ds-4zjcd             2/2       Running   0          4m
kube-system   kube-proxy-v84jz                  1/1       Running   0          4m
kube-system   kube-scheduler-sriov-1            1/1       Running   0          3m
```

# Create networks and launch a multi-homed pod

Once the cluster is ready, we create a custom resource definition for the k8s networks,
create a couple of networks via bridge and SRIOV plugins, and then finally launch a pod
making use of these newly created networks.  This is all handled by ```./setup.sh```.

# Check it out

You can exec into the pod and check the network configuration.  You should see three devices:
```
$ sudo -E kubectl exec -it ubuntu-sriov-fun -- bash -c "ifconfig"
eth0      Link encap:Ethernet  HWaddr 0a:58:0a:f4:00:fb  
          inet addr:10.244.0.251  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::c4ff:ebff:fe45:c509/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1450  Metric:1
          RX packets:21 errors:0 dropped:0 overruns:0 frame:0
          TX packets:8 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:2560 (2.5 KB)  TX bytes:648 (648.0 B)

lo        Link encap:Local Loopback  
          inet addr:127.0.0.1  Mask:255.0.0.0
          inet6 addr: ::1/128 Scope:Host
          UP LOOPBACK RUNNING  MTU:65536  Metric:1
          RX packets:0 errors:0 dropped:0 overruns:0 frame:0
          TX packets:0 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1 
          RX bytes:0 (0.0 B)  TX bytes:0 (0.0 B)

net0      Link encap:Ethernet  HWaddr 9a:72:e7:2b:00:00  
          inet addr:10.55.206.6  Bcast:0.0.0.0  Mask:255.255.255.192
          inet6 addr: fe80::9872:e7ff:fe2b:0/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:174 errors:0 dropped:0 overruns:0 frame:0
          TX packets:897 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:36812 (36.8 KB)  TX bytes:95559 (95.5 KB)
```

These map to:
* a virtual device (veth thanks to bridge plugin)
```
$ sudo -E kubectl exec -it ubuntu-sriov-fun -- bash -c "readlink /sys/class/net/eth0"
../../devices/virtual/net/eth0
```
*  and a physical device (a VF thanks to the SRIOV plugin):
```
$ sudo -E kubectl exec -it ubuntu-sriov-fun -- bash -c "readlink /sys/class/net/net0"
../../devices/pci0000:00/0000:00:01.0/0000:02:10.0/net/net0
```
