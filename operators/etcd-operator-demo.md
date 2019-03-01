# Etcd Operator Demo

**Start minishift cluster locally.**
```
./start_minishift.sh
```

**Login as admin**
```
oc login -u system:admin
```

**Lets create the Custom Resource Definition (CRD) for the Etcd Operator:**
```
cat > etcd-operator-crd.yaml<<EOF
apiVersion: apiextensions.k8s.io/v1beta1
kind: CustomResourceDefinition
metadata:
  name: etcdclusters.etcd.database.coreos.com
spec:
  group: etcd.database.coreos.com
  names:
    kind: EtcdCluster
    listKind: EtcdClusterList
    plural: etcdclusters
    shortNames:
    - etcdclus
    - etcd
    singular: etcdcluster
  scope: Namespaced
  version: v1beta2
  versions:
  - name: v1beta2
    served: true
    storage: true
EOF

oc create -f etcd-operator-crd.yaml
```
**Get status of the  Custom Resource Definition (CRD)**
```
oc get crd
```
**Create the dedicated Service Account that is responsible for running the Etcd Operator**
```
cat > etcd-operator-sa.yaml<<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  name: etcd-operator-sa
EOF

oc create -f etcd-operator-sa.yaml
```

**Lets confirm the Service Account was created**
```
oc get sa
```

**Lets create the Role that the etcd-operator-sa Service Account will need for authorization against  the Kubernetes API:**
Note: This is a demo make sure you define on your own security permissions  if you are using as a template. 
```
cat > etcd-operator-role.yaml<<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: etcd-operator-role
rules:
- apiGroups:
  - etcd.database.coreos.com
  resources:
  - etcdclusters
  - etcdbackups
  - etcdrestores
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - pods
  - services
  - endpoints
  - persistentvolumeclaims
  - events
  verbs:
  - '*'
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - '*'
- apiGroups:
  - ""
  resources:
  - secrets
  verbs:
  - get
EOF

oc create -f etcd-operator-role.yaml
```

**Lets confirm the Role was created**
```
oc get roles
```
**Create the RoleBinding to bind the etcd-operator-role Role to the etcd-operator-sa Service Account:**
```
cat > etcd-operator-rolebinding.yaml<<EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: etcd-operator-rolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: etcd-operator-role
subjects:
- kind: ServiceAccount
  name: etcd-operator-sa
  namespace: myproject
EOF

oc create -f etcd-operator-rolebinding.yaml
```

**Lets confirm the RoleBinding was created**
```
oc get rolebindings
```


**Create the Etcd Operator Deployment**
```
cat > etcd-operator-deployment.yaml<<EOF
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  labels:
    name: etcdoperator
  name: etcd-operator
spec:
  replicas: 1
  selector:
    matchLabels:
      name: etcd-operator
  template:
    metadata:
      labels:
        name: etcd-operator
    spec:
      containers:
      - command:
        - etcd-operator
        - --create-crd=false
        env:
        - name: MY_POD_NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
        - name: MY_POD_NAME
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.name
        image: quay.io/coreos/etcd-operator@sha256:c0301e4686c3ed4206e370b42de5a3bd2229b9fb4906cf85f3f30650424abec2
        imagePullPolicy: IfNotPresent
        name: etcd-operator
      serviceAccountName: etcd-operator-sa
EOF

oc create -f etcd-operator-deployment.yaml
```

**Lets confirm the deployment was created**
```
oc get deploy
```

**Lets confirm the pods are running**
```
oc get pods -w
```
**Display to operators endpoints**
```
oc get endpoints etcd-operator -o yaml
```

**Create an Etcd cluster by referring to the new Custom Resource, EtcdCluster.**
```
cat > etcd-operator-cr.yaml<<EOF
apiVersion: etcd.database.coreos.com/v1beta2
kind: EtcdCluster
metadata:
  name: example-etcd-cluster
spec:
  size: 3
  version: 3.1.10
EOF

oc create -f etcd-operator-cr.yaml
```

**Checking that the cluster object was created.**
```
oc get etcdclusters
```

**Watch the pods in the Etcd cluster get created.**
```
oc get pods -l etcd_cluster=example-etcd-cluster -w
```

**Delete your Etcd cluster**
```
oc delete etcdcluster example-etcd-cluster
```

**Delete the Etcd Operator**
```
oc delete deployment etcd-operator
```

**Delete the Etcd CRD:**
```
oc delete crd etcdclusters.etcd.database.coreos.com
```

**Optional: Delete Minishift Cluster**
```
./delete_minishift.sh
```

**Run the Etcd Operator Training on learn.openshift.com for in depth training.**  
[Kubernetes API Fundamentals](https://learn.openshift.com/operatorframework/k8s-api-fundamentals/)
