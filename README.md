# A Collection of OpenShift demos

<!-- TOC -->

- [A Collection of OpenShift demos](#a-collection-of-openshift-demos)
- [Implement simple pods to show docker approach and node scheduling](#implement-simple-pods-to-show-docker-approach-and-node-scheduling)
- [Source to Image builds, with webhook triggers for builds](#source-to-image-builds-with-webhook-triggers-for-builds)
- [Build from template for two tier -- App Server and Backend](#build-from-template-for-two-tier----app-server-and-backend)
- [Python (Django)  - PostgreSQL Backend -or-](#python-django----postgresql-backend--or-)
- [Java (Tomcat) - PostgreSQL Backend](#java-tomcat---postgresql-backend)
- [ConfigMaps](#configmaps)
- [Persistent Storage - OCS](#persistent-storage---ocs)
- [Pipelines](#pipelines)
- [Operators](#operators)
- [Code ready Workspaces](#code-ready-workspaces)
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
### Source to Image builds, with webhook triggers for builds

### Build from template for two tier -- App Server and Backend

### Python (Django)  - PostgreSQL Backend


### ConfigMaps
```

```
### Persistent Storage - OCS

### Pipelines
https://docs.openshift.com/container-platform/3.11/dev_guide/dev_tutorials/openshift_pipeline.html
```
oc new-project test-jenkins
oc new-app jenkins-ephemeral
oc status | grep pods
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
