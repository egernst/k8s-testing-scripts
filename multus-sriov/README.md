# Bring up cluster

We assume that k8s is cleaned up and not running on the system.  

First, the script manually copies the cni config to /etc/cni/net.d,
then brings up the cluster via kubeadm.  Once up, we start up flannel,
which is the default network configured with this multus setup.  We then
sit and wait for all of the pods to come up.  ctl-c to stop watching the pods come up...

Once ready, you should see the following:

# Create networks and launch a multi-homed pod

Once the cluster is ready, we create a custom resource definition for the k8s networks,
create a couple of networks via bridge and SRIOV plugins, and then finally launch a pod
making use of these newly created networks

# Check it out

You can exec into the pod and check the network configuration.  You should see three devices:
