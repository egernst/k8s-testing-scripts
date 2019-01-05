#!/usr/bin/env bash

########################
# include the magic
########################
. ./demo-magic.sh


########################
# Configure the options
########################

#
# speed at which to simulate typing. bigger num = faster
#
# TYPE_SPEED=20

#
# custom prompt
#
# see http://www.tldp.org/HOWTO/Bash-Prompt-HOWTO/bash-prompt-escape-sequences.html for escape sequences
#
DEMO_PROMPT="${GREEN}➜ ${CYAN}\W "

# hide the evidence
clear


# put your demo awesomeness here

pe "# This is a demonstration of setting up a Kubernetes cluster
    #  utilizing CRI-O + runtimeClass + Kata Containers with handlers
    #  for both QEMU and Firecracker hypervisors."
pe "# We are setup on Clear Linux distro, with binaries already on the host
    #  for Kata, CRI-O and Kubernetes."

pe "kubectl version"

pe "sudo crictl version"

pe "kata-runtime version"

pe "# Using our example scripts, let's bring up the kubernetes cluster:
    #  In this case, the script will just bring up the cluster and configure
    #  CNI (canal)."

pe "/vagrant/create_stack.sh minimal"

pe "# Let's wait for the cluster to be up:"

pe "watch -d kubectl get pods --all-namespaces"

pe "# Now that the cluster is up, let's configure it for our runtime
    #  classes"

pe "kubectl apply -f runtimeclass_crd.yaml"
pe "cat kata-qemu-runtimeClass.yaml"
pe "kubectl apply -f kata-qemu-runtimeClass.yaml"
pe "kubectl apply -f kata-fc-runtimeClass.yaml"

pe "# Let's verify that the runtime classes have indeed been registered:"
pe "kubectl get runtimeclasses -o=custom-columns=NAME:.metadata.name,HANDLER:.spec.runtimeHandler,TIMESTAMP:.metadata.creationTimestamp"
pe "# We have two classes defined for Kata:
    # -kata-qemu, a runtime which utilizes hardware virtualiztion through QEMU, and
    # kata -fc, a runtime which utilizes hardware virtualization through the microVM hypervisor, 
    # Firecracker."

pe "# Now let's start a standard deployment, which will utilize the default, runc:"
pe "kubectl run -it busybox --image busybox"
pe "uname -r"

pe "# Note the pod observed in bottom pane, and the matching kernel, which is
    #  shared between the host and the runc based pod."
pe "# Let's patch the running deployment to make use of QEMU for isolation. We simply need to
    #  add the runtimeClass field to the deployment. See the following patch file:"
pe "cat  kata-qemu-patch.yaml"
pe "# Patch the deployment:"
pe 'kubectl patch deploy busybox --patch "$(cat kata-qemu-patch.yaml)"'

pe "# See that a QEMU process can be observed below, and the deployment's pod is
    #  restarted"

pe "# Let's checkout the kernel and PCI devices within the new container"
pe 'POD=$(kubectl get pod -l run=busybox -o jsonpath="{.items[0].metadata.name}")'
pe "kubectl exec -it $POD -- sh -c 'lspci; uname -r'"

pe "# Now let's go ahead and patch the deployment to make use of the kata-fc runtime
    #  handler:"

pe 'kubectl patch deploy busybox --patch "$(cat kata-fc-patch.yaml)"'

pe "# See that a firecracker hypervisor is started, and the qemu is removed"
pe "# Firecracker is described as a microVM, with a very limited device model set.
    #  Let's take a look for ourselves..."
 
pe 'POD=$(kubectl get pod -l run=busybox -o jsonpath="{.items[0].metadata.name}")'
pe "kubectl exec -it $POD -- sh -c 'lspci; uname -r'"

pe "# indeed - PCI isn't being used, but virtio-mmio instead:"

pe "kubectl exec -it $POD -- sh -c 'dmesg | grep Kernel\ command'"

pe "# And finally, to show it all working together, three deployments, creating
    #  three pods, each utilizing either runc, Kata with QEMU, or Kata with Firecracker:"

pe "kubectl apply -f deploy-example/" 

pe 'curl -w "\n" -s $(kubectl get svc php-apache-runc | awk "NR==2 {print $3}")'
pe 'curl -w "\n" -s $(kubectl get svc php-apache-kata-qemu | awk "NR==2 {print $3}")'
pe 'curl -w "\n" -s $(kubectl get svc php-apache-kata-fc | awk "NR==2 {print $3}")'
# show a prompt so as not to reveal our true nature after
# the demo has concluded
p ""
