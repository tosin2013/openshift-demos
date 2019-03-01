# Notes
 curl http://localhost:8991/api/v1/ | jq .resources[].name

### explain command
oc explain command
kubectl explain command

# versions
start with v1alpha1 for your apiversion

# explain how the kubernetes api works

1. Define the kubernetes api
2. define your controller

# two ways to run an operator
1. Inside the cluster
2. outside the cluster

# Development options
1. Go - Golang
2. Ansible
3. Go and Ansible
4. Helm - geared towards state list applications


workshop.coreostrain.me
username: operator
password: coreostrainme

#client-go

# watch events
 oc get pods -w

# Check on deletion
$ oc get deployment finalizer-test -o yaml | grep 'deletionGracePeriodSeconds\|deletionTimestamp'
```
deletionGracePeriodSeconds: 0
deletionTimestamp: 2019-02-27T19:16:06Z
```  

# Follow logs in real time
```
export ETCD_OPERATOR_POD=$(oc get pods -l name=etcd-operator -o jsonpath='{.items[0].metadata.name}')
oc logs $ETCD_OPERATOR_POD -f
```

# oc api commands
oc api-versions

#Links
Chat
#kubernetes-operators
Mailing List
operator-framework
GitHub Issues
operator-sdk
OpenShift Commons - Operator Framework
Every third Friday of the month at 12pm EST
Workshop Slides
Slides

# Katacoda
https://learn.openshift.com/training/

Project Name: ProjectTest
Primary resource: ProjectTest (Kind: ProjectTest)
Secondary resource: Deployment -> ProjectTest
- createdeploy -> client.create the

# PODSET:
Project Name: Podset
Primary resource: Podset (Kind: PodSet)
Secondary resource: PODS -> (Owned by a particular PODSET)
- GetReplicas: 3 -> looks at labels to determine count.
https://medium.com/devopslinks/writing-your-first-kubernetes-operator-8f3df4453234

# operators can use multiple configs
* primary: app
* Sec: deployment

* Primary: appconfig
* Sec: configmap

* Primary: appBackup
* - a reconcile loop for each set (aka: controller)

operator-sdk new podset-operator --type=go --skip-git-init
type can be ansible,go,Helm

operator-sdk add api --api-version=app.example.com/v1alpha1 --kind=App # Kind will be the name of the top level app

# How to build an operator example
1. Can i use any existing controllers in kubernetes before i start coding?


https://blog.openshift.com/make-a-kubernetes-operator-in-15-minutes-with-helm/
-----------
client go
