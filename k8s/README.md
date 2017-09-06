## Generic Example:

## Side Car Example:

1. Bring up k8s cluster

2. Start side car pod

```
create -f ../side-car.yaml
```

3. Check the logs:

```
 kubectl logs counter count-log-1
 kubectl logs counter count-log-2
 ```
