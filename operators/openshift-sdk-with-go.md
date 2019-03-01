# Operator SDK with Go (PodSet)
**Start minishift cluster locally.**  
```
./start_minishift.sh
```

**Login as admin**  
```
oc login -u system:admin
```
**Ensure you are using myproject**
```
oc project myproject
```

**Configure Your machine to use operator sdk**  
[Operator-SDK Installation](operator-sdk-installation.md)

**Create a new Go-based Operator SDK project for the PodSet (PodSet )**
```
export PATH=$PATH:/usr/local/bin:$GOPATH/bin
export GOPATH=$HOME/go
mkdir -p $GOPATH/src/github.com/redhat/
cd $GOPATH/src/github.com/redhat/
operator-sdk new podset-operator --type=go #--skip-git-init
```
**cd into podset deirectory**
```
cd podset-operator/
```

**Lets add a new Custom Resource Definition(CRD) API called PodSet**
```
operator-sdk add api --api-version=app.example.com/v1alpha1 --kind=PodSet
```
**Add a new Controller to the project that will watch and reconcile the PodSet resource**
```
operator-sdk add controller --api-version=app.example.com/v1alpha1 --kind=PodSet
```

**Confirm the CRD was successfully created.**
```
oc get crd
```

**Open IDE or use vim**
```
code .
or
atom .
```

**Lets inspect the Custom Resource Definition manifest***
```
cat deploy/crds/app_v1alpha1_podset_crd.yaml
```

**Deploy your PodSet Custom Resource Definition to the live OpenShift Cluster.**
```
oc create -f deploy/crds/app_v1alpha1_podset_crd.yaml
```

**edit pkg/apis/app/v1alpha1/podset_types.go file on lines 10 - 18**
```
// PodSetSpec defines the desired state of PodSet
type PodSetSpec struct {
    Replicas int32 `json:"replicas"`
}

// PodSetStatus defines the observed state of PodSet
type PodSetStatus struct {
    PodNames []string `json:"podNames"`
}
```
**After modifying the podset_types.go file always run the following command to update the generated code for that resource type:**
```
operator-sdk generate k8s
```

**Edit the  pkg/controller/podset/podset_controller.go**
```
curl -OL https://gist.githubusercontent.com/madorn/bba19ea9bd4d0086b672a38ea5c65422/raw/a663f0f8a67c544134460c203f50d26b746faed4/podset_controller.go
# compare and replace with code found in the above link.
mv podset_controller.go podset_controller.bak.go
git diff  podset_controller.go pkg/controller/podset/podset_controller.go # or use IDE
```

**Replace/Customize the Operator Logic**
```
vim pkg/controller/podset/podset_controller.go
rm podset_controller.bak.go
```

**Run the Operator Locally (Inside the Cluster)**
Test our logic by running our Operator outside the cluster via our kubeconfig credentials.
```
export OPERATOR_NAME=podset-operator #used by prometheus
operator-sdk up local --namespace myproject
```

**Login Quay**
```
docker login -u="username" -p="password" quay.io
```

**Lets build and push the app-operator image to a public registry such as quay.io**
```
ENDPOINT="takinosh"
OPERATORNAME="podset-operator"
operator-sdk build quay.io/${ENDPOINT}/${OPERATORNAME}
docker push quay.io/${ENDPOINT}/${OPERATORNAME}
```
**Confirm quay.io repo is public**

**Lets update the operator manifest to use the built image name (if you are performing these steps on OSX, see note below)**
```
sed -i 's|REPLACE_IMAGE|quay.io/'${ENDPOINT}'/'${OPERATORNAME}'|g' deploy/operator.yaml
# On OSX use:
sed -i "" 's|REPLACE_IMAGE|quay.io/'${ENDPOINT}'/'${OPERATORNAME}'|g' deploy/operator.yaml
```

**Check if deploy/operator.yaml is correct**
```
grep "${ENDPOINT}/${OPERATORNAME}" deploy/operator.yaml
```

**Setup Service Account**
```
oc create -f deploy/service_account.yaml
```
**Setup RBAC**
```
oc create -f deploy/role.yaml
oc create -f deploy/role_binding.yaml
```

**In a new terminal or IE, inspect the Custom Resource manifest:**
```
cat deploy/crds/app_v1alpha1_podset_cr.yaml
```

**Ensure your kind: PodSet Custom Resource (CR) is updated with spec.replicas. Manually change if needed.**
```
apiVersion: app.example.com/v1alpha1
kind: PodSet
metadata:
  name: example-podset
spec:
  replicas: 3
```

**Deploy the app-operator**
```
oc create -f deploy/operator.yaml
```

**Runs the kube-openapi OpenAPIv3 code generator for all Custom Resource Definition (CRD) API tagged fields under pkg/apis/....**
```
operator-sdk generate openapi
```

**Deploy your PodSet Custom Resource to the live OpenShift Cluster:**
```
oc create -f deploy/crds/app_v1alpha1_podset_cr.yaml
```
**Check your Minishift cluster:**
![Go operator Deployment ](images/go-operator-deployment.png)
![pods](images/go-operator.png)

**Optional: Delete Minishift Cluster**  
```
./delete_minishift.sh
```

**Run the Etcd Operator Training on learn.openshift.com for in depth training.**  
[openshift - Operator SDK with Go (PodSet)](https://learn.openshift.com/operatorframework/go-operator-podset/)

**operator-sdk GitHub**
[operator-sdk](https://github.com/operator-framework/operator-sdk)
[Workflow](https://github.com/operator-framework/operator-sdk#workflow)
[Quick Start](https://github.com/operator-framework/operator-sdk#quick-start)
