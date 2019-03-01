# Operator SDK with Ansible - WIP
**Start minishift cluster locally.**  
```
./start_minishift.sh
```

**Configure Your machine to use operator sdk**  
[Operator-SDK Installation](operator-sdk-installation.md)

**Create a new Go-based Operator SDK project for the PodSet (PodSet )**
```
export PATH=$PATH:/usr/local/bin:$GOPATH/bin
export GOPATH=$HOME/go
mkdir -p $GOPATH/src/github.com/redhat/
cd $GOPATH/src/github.com/redhat/
operator-sdk new memcached-operator --api-version=cache.example.com/v1alpha1 --kind=Memcached --type=ansible

```

**cd into podset deirectory**
```
cd memcached-operator/
```

**Open IDE or use vim**
```
code .
or
atom .
```

**Login to OpenShift as the develope**
```
oc login -u developer -p developer
```

**Ensure you are using myproject**
```
oc project myproject
```

**Lets add a new Custom Resource Definition(CRD) API called PodSet**
[memcached_operator_role](https://galaxy.ansible.com/dymurray/memcached_operator_role)
```
ansible-galaxy install dymurray.memcached_operator_role -p ./roles
```

**Add a new Controller to the project that will watch and reconcile the PodSet resource**
```
rm -rf ./roles/Memcached
```

**Review the memcached role defaults**
```
cat roles/dymurray.memcached_operator_role/defaults/main.yml
```

**Review the memcached tasks**
```
cat roles/dymurray.memcached_operator_role/tasks/main.yml
```

```
cat > watches.yaml <<YAML
---
- version: v1alpha1
  group: cache.example.com
  kind: Memcached
  role: /opt/ansible/roles/dymurray.memcached_operator_role
YAML
```



```
oc create -f deploy/crds/cache_v1alpha1_memcached_crd.yaml --as system:admin

```

```
oc get crd  --as system:admin

```
**Login Quay**
```
docker login -u="username" -p="password" quay.io
```

**Lets build and push the app-operator image to a public registry such as quay.io**
```
ENDPOINT="takinosh"
$
$ docker push quay.io/example/memcached-operator:v0.0.1
operator-sdk build quay.io/${ENDPOINT}/memcached-operator:v0.0.1
docker push quay.io/${ENDPOINT}/memcached-operator:v0.0.1
```

**Lets update the operator manifest to use the built image name (if you are performing these steps on OSX, see note below)**
```
sed -i 's|REPLACE_IMAGE|quay.io/${ENDPOINT}/memcached-operator:v0.0.1|g' deploy/operator.yaml
# On OSX use:
sed -i ""  's|REPLACE_IMAGE|quay.io/'${ENDPOINT}'/memcached-operator:v0.0.1|g' deploy/operator.yaml
```


**Check if deploy/operator.yaml is correct**
```
grep "${ENDPOINT}/${OPERATORNAME}" deploy/operator.yaml
```

**Setup Service Account**
```
oc create -f deploy/service_account.yaml --as system:admin
```

**Setup RBAC**
```
oc create -f deploy/role.yaml --as system:admin
oc create -f deploy/role_binding.yaml --as system:admin
```

**In a new terminal or IE, inspect the Custom Resource manifest:**
```
cat deploy/crds/cache_v1alpha1_memcached_cr.yaml
```

**Deploy the app-operator**
```
oc create -f deploy/operator.yaml --as system:admin
```

**Create the Memcached CR.**
```
oc create -f deploy/crds/cache_v1alpha1_memcached_cr.yaml --as system:admin
```

cat > test.yaml <<YAML
# Required because of inter namespace communication
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
 name:  myproject
rules:
- apiGroups: ["", "extensions"]
  resources: ["memcacheds.cache.example.com"]
  verbs: ["get", "list"]
YAML

system:serviceaccount:myproject:memcached-operator

oc adm policy add-role-to-user admin developer -n myproject

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
 oc create -f test.yaml


**Run the operator locally with the default kubernetes config file present at $HOME/.kube/config.**
```
oc login -u system:admin
operator-sdk up local --namespace myproject
```
