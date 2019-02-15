# A Collection of OpenShift demos

<!-- TOC -->

- [A Collection of OpenShift demos](#a-collection-of-openshift-demos)
    - [OpenShift Scalability](#openshift-scalability)
    - [Source to Image builds](#source-to-image-builds)
    - [Source to Image builds, with webhook triggers for builds](#source-to-image-builds-with-webhook-triggers-for-builds)
    - [Build from template for two tier -- App Server and Backend](#build-from-template-for-two-tier----app-server-and-backend)
    - [Python (Django)  - PostgreSQL Backend](#python-django----postgresql-backend)
    - [ConfigMaps](#configmaps)
    - [Persistent Storage Using Gluster - OCS](#persistent-storage-using-gluster---ocs)
    - [Persistent Storage Using NFS - OCS](#persistent-storage-using-nfs---ocs)
    - [Pipelines](#pipelines)
    - [Operators](#operators)
    - [Code Ready Workspaces](#code-ready-workspaces)
    - [Authors](#authors)

<!-- /TOC -->

### OpenShift Scalability
```
oc new-app https://github.com/sclorg/nodejs-ex
oc get pods  | grep nodejs
oc expose svc/nodejs-ex
oc scale dc nodejs-ex --replicas=3
oc get pods | grep nodejs
oc scale dc nodejs-ex --replicas=1
oc get pods | grep nodejs
oc delete all --selector app=nodejs-ex
```
### Source to Image builds
[Source-to-Image Builders]()

### Source to Image builds, with webhook triggers for builds
[Source-to-Image Builders with web hooks]()

### Build from template for two tier -- App Server and Backend

### Python (Django)  - PostgreSQL Backend


### ConfigMaps
[Using ConfigMaps](https://github.com/tosin2013/openshift-demos/blob/master/configmaps.md)

### Persistent Storage Using Gluster - OCS

### Persistent Storage Using NFS - OCS

### Pipelines
https://docs.openshift.com/container-platform/3.11/dev_guide/dev_tutorials/openshift_pipeline.html
```
oc new-project test-jenkins
# If you are using minishift use
oc project myproject
oc new-app jenkins-ephemeral
oc status
oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/jenkins/pipeline/nodejs-sample-pipeline.yaml
```

### Operators

### Code Ready Workspaces
[Download Red Hat CodeReady Workspaces](https://developers.redhat.com/products/codeready-workspaces/download/)  
[Operator Installer - 1.0.0](https://developers.redhat.com/download-manager/file/codeready-workspaces-1.0.0.GA-operator-installer.tar.gz)  
```
oc login https://master.youropenshift.com:8443
tar -zxvf codeready-workspaces-<version>-operator-installer.tar.gz
cd codeready-workspaces-operator-installer/
#optional: Modify config.yaml
./deploy.sh  --deploy config.yaml --project=your-project
```
## Authors

* **Tosin Akinosho** - *Initial work* - [tosin2013](https://github.com/tosin2013)
