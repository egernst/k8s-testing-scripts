Some helper files for quickly running a couple of k8s tests showcasing Clear Containers.

From this, you should be able to quickly recreate https://asciinema.org/a/135837 and https://asciinema.org/a/134681

test.sh contains a script which will do cleanup, bringup a single machine cluster, setup flannel

## Generic Example:

1. Start the cluster by using test.sh

2. Start a trusted and untrusted pod:
sudo -E kubectl create -f ../nginx-trusted.yaml
sudo -E kubectl create -f ../nginx-untrusted.yaml



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
