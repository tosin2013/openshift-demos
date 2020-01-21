# Resource Quotas and Limits

**Login to OpenShift**
```
# in standard OpenShift deployment
oc login -u your_username
# in minishift
oc login -u developer
```

**lets create the source to image project**
```
oc new-project quota-limit-demo

#minishift use myproject
oc project myproject
```

**See that quota limits do not exisit in project**
```
$  oc get quota -n quota-limit-demo
No resources found.
$  oc describe quota core-object-counts -n quota-limit-demo
```

## Set limits As administrator
```
cat <<YAML > core-object-counts.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: core-object-counts
spec:
  hard:
    configmaps: "1"
    persistentvolumeclaims: "1"
    replicationcontrollers: "1"
    secrets: "1"
    services: "1"
YAML
```

```
oc create -f core-object-counts.yaml -n quota-limit-demo
```

```
oc describe quota core-object-counts -n quota-limit-demo
```

## Test Quota
```
oc new-app https://github.com/sclorg/nodejs-ex
oc new-app cakephp-mysql-example
```

```
 oc delete quota  core-object-counts
```


```
cat <<YAML > compute-resources.yaml
apiVersion: v1
kind: ResourceQuota
metadata:
  name: compute-resources
spec:
  hard:
    pods: "1"
    requests.cpu: "1"
    limits.cpu: "1"
    limits.memory: 1Gi
YAML
```

```
oc create -f compute-resources.yaml -n quota-limit-demo
```

```
oc describe quota compute-resources
```


## Test Quota
Attempt to create application under the catalog with higher values.



```
 oc delete quota  compute-resources
```


### Test limits
```
oc new-app centos/python-35-centos7~https://github.com/sclorg/django-ex
oc expose svc/django-ex
oc logs -f bc/django-ex
```

```
cat <<YAML > core-resource-limits.yaml
apiVersion: "v1"
kind: "LimitRange"
metadata:
  name: "core-resource-limits"
spec:
  limits:
    - type: "Pod"
      max:
        cpu: "2"
        memory: "1Gi"
      min:
        cpu: "200m"
        memory: "6Mi"
    - type: "Container"
      max:
        cpu: "2"
        memory: "1Gi"
      min:
        cpu: "100m"
        memory: "4Mi"
      default:
        cpu: "300m"
        memory: "200Mi"
      defaultRequest:
        cpu: "200m"
        memory: "100Mi"
      maxLimitRequestRatio:
        cpu: "10"
YAML
```

```
oc create -f core-resource-limits.yaml -n quota-limit-demo
```
```
oc describe limits core-resource-limits
```

```
for i in {1..10000};do curl -s -w "%{time_total}\n" -o /dev/null http://django-ex-quota-limit-demo.apps.ocp.tosinakinosho.com/; done

```
