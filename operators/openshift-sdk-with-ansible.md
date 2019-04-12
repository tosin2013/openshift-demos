<<<<<<< HEAD
# Operator SDK with Ansible - WIP


https://youtu.be/Smk9oQp7YMY?t=75

=======
# Operator SDK with Ansible
>>>>>>> 9611c069735cf1c9ac0d391fb5194c32bd964109
**Start minishift cluster locally.**  
```
./start_minishift.sh
```

**Configure Your machine to use operator sdk**  
[Operator-SDK Installation](operator-sdk-installation.md)

**Create a new Go-based Operator SDK project for the PodSet (PodSet )**
```
export GOPATH=$HOME/go  
export PATH=$PATH:/usr/local/bin:$GOPATH/bin
mkdir -p $GOPATH/src/github.com/redhat/
cd $GOPATH/src/github.com/redhat/
###
## Confirm operator sdk v0.3.0
## operator-sdk --version
###
operator-sdk new memcached-operator --api-version=cache.example.com/v1alpha1 --kind=Memcached --type=ansible

```

**cd into podset directory**
```
cd memcached-operator/
```

**directory structure**
```
$ tree
.
├── README.md
├── delete_minishift.sh
├── etcd-operator-demo.md
├── kubernetes-api.md
├── memcached-operator
│   ├── build
│   │   └── Dockerfile
│   ├── deploy
│   │   ├── crds
│   │   │   ├── cache_v1alpha1_memcached_cr.yaml
│   │   │   └── cache_v1alpha1_memcached_crd.yaml
│   │   ├── operator.yaml
│   │   ├── role.yaml
│   │   ├── role_binding.yaml
│   │   └── service_account.yaml
│   ├── roles
│   │   └── Memcached
│   │       ├── README.md
│   │       ├── defaults
│   │       │   └── main.yml
│   │       ├── files
│   │       ├── handlers
│   │       │   └── main.yml
│   │       ├── meta
│   │       │   └── main.yml
│   │       ├── tasks
│   │       │   └── main.yml
│   │       ├── templates
│   │       ├── tests
│   │       │   ├── inventory
│   │       │   └── test.yml
│   │       └── vars
│   │           └── main.yml
│   └── watches.yaml
├── notes.md
├── op-sdk-setup.sh
├── openshift-sdk-with-ansible.md
├── openshift-sdk-with-go.md
├── operator-sdk-installation.md
└── start_minishift.sh
```

**Open IDE or use vim**
```
code .
or
atom .
```

 echo "size: 1" >> roles/Memcached/defaults/main.yml
 cat roles/Memcached/defaults/main.yml

**Login to OpenShift as the develope**
```
oc login -u system:admin
```

**Ensure you are using myproject**
```
oc project myproject
```

```
oc create -f deploy/crds/cache_v1alpha1_memcached_crd.yaml

```

```
oc get crd

```

<<<<<<< HEAD
**Setup Service Account**
=======
**Override role path to point to dymurray.memcached_operator_role**
>>>>>>> 9611c069735cf1c9ac0d391fb5194c32bd964109
```
oc create -f deploy/service_account.yaml
```

<<<<<<< HEAD
**Setup RBAC**
=======

**Create memcached Custom Resource Definition (CRD)**
>>>>>>> 9611c069735cf1c9ac0d391fb5194c32bd964109
```
oc create -f deploy/role.yaml
oc create -f deploy/role_binding.yaml
```

<<<<<<< HEAD

=======
**Check status of Custom Resource Definition***
```
oc get crd  --as system:admin

```

>>>>>>> 9611c069735cf1c9ac0d391fb5194c32bd964109
**Login Quay**
```
docker login -u="username" -p="password" quay.io
```

**Lets build and push the app-operator image to a public registry such as quay.io**
```
<<<<<<< HEAD
ENDPOINT="takinosh"
operator-sdk build quay.io/${ENDPOINT}/memcached-ansible-operator:v0.0.1
docker push quay.io/${ENDPOINT}/memcached-ansible-operator:v0.0.1
=======
ENDPOINT="tosin2013"
operator-sdk build quay.io/${ENDPOINT}/memcached-operator:v0.0.1
docker push quay.io/${ENDPOINT}/memcached-operator:v0.0.1
>>>>>>> 9611c069735cf1c9ac0d391fb5194c32bd964109
```

**Confirm quay.io repo is public**

**Lets update the operator manifest to use the built image name (if you are performing these steps on OSX, see note below)**
```
sed -i 's|REPLACE_IMAGE|quay.io/'${ENDPOINT}'/memcached-ansible-operator:v0.0.1|g' deploy/operator.yaml
# On OSX use:
sed -i ""  's|REPLACE_IMAGE|quay.io/'${ENDPOINT}'/memcached-ansible-operator:v0.0.1|g' deploy/operator.yaml
```


**Check if deploy/operator.yaml is correct**
```
grep "${ENDPOINT}/${OPERATORNAME}" deploy/operator.yaml
```

**Deploy the app-operator**
```
oc create -f deploy/operator.yaml
```

```
oc get deployment
```

**Deploy the app-operator**
```
oc create -f deploy/operator.yaml --as system:admin
```

<<<<<<< HEAD
=======
**Check deployment**
```
oc get deployment
```

**In a new terminal or IE, inspect the Custom Resource manifest:**
```
cat deploy/crds/cache_v1alpha1_memcached_cr.yaml
```

>>>>>>> 9611c069735cf1c9ac0d391fb5194c32bd964109
**Create the Memcached CR.**
```
oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml
```

**Check deployment**
```
oc get deployment
```

![deployment](https://github.com/tosin2013/openshift-demos/blob/master/images/ansible-deployment.png?raw=true)
![pods](https://github.com/tosin2013/openshift-demos/blob/master/images/ansible-pods.png?raw=true)

**Optional: Delete Minishift Cluster**  
```
./delete_minishift.sh
```


**Run the Etcd Operator Training on learn.openshift.com for in depth training.**  
[Ansible Kubernetes Module](https://learn.openshift.com/ansibleop/ansible-k8s-modules/)

**operator-sdk GitHub**
[operator-sdk-ansible](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/user-guide.md)

**Information Flow for Ansible Operator**
[Information Flow for Ansible Operator](https://github.com/operator-framework/operator-sdk/blob/master/doc/ansible/information-flow-ansible-operator.md#information-flow-for-ansible-operator)

**operator sdk samples**
[operator-framework/operator-sdk-samples](https://github.com/operator-framework/operator-sdk-samples/tree/master/ansible)

# Local testing
**Update watches to use ansible role**
```
LOCALROLEPATH=$(ls -d $(pwd)/roles/dymurray.memcached_operator_role)
cat > watches.yaml <<YAML
---
- version: v1alpha1
  group: cache.example.com
  kind: Memcached
  role: ${LOCALROLEPATH}
YAML
```

**Run the operator locally with the default kubernetes config file present at $HOME/.kube/config.**
```
oc login -u system:admin
operator-sdk up local --namespace myproject
```
