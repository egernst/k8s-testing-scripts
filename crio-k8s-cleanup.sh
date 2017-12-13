sudo kubeadm reset
for c in `sudo crictl ps | cut -c -10 | grep -v CONTAIN`; do sudo crictl stop $c; done
for c in `sudo crictl ps | cut -c -10 | grep -v CONTAIN`; do sudo crictl rm $c; done
for c in `sudo crio-runc list -q`; do sudo crio-runc kill $c; done
for c in `sudo crio-runc list -q`; do sudo crio-runc delete $c; done
for c in `sudo cc-runtime list -q`; do sudo cc-runtime kill $c; done
for c in `sudo cc-runtime list -q`; do sudo cc-runtime delete $c; done
