Some helper files for quickly running a couple of k8s tests showcasing Clear Containers.

## Generic Example:

test.sh contains a script which will do cleanup, bringup a single machine cluster, setup flannel and then startup 2 pods: a trusted nginx pod and an untrusted nginx pod.


## Side Car Example:

1. Bring up k8s cluster by making use of test.sh

2. Start side car pod

```
create -f ../side-car.yaml
```

3. Check the logs:

```
 kubectl logs counter count-log-1
 kubectl logs counter count-log-2
 ```
