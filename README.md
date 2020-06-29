# A Collection of OpenShift demos

<!-- TOC -->

- [A Collection of OpenShift demos](#a-collection-of-openshift-demos)
  - [Installing OpenShift CLI v4.x](#installing-openshift-cli-v4x)
  - [Installing OpenShift CLI v3.11](#installing-openshift-cli-v311)
  - [OpenShift Project Creation](#openshift-project-creation)
  - [OpenShift User Creation](#openshift-user-creation)
  - [Update users password](#update-users-password)
  - [Remove user from OpenShift](#remove-user-from-openshift)
  - [OpenShift Scalability](#openshift-scalability)
  - [OpenShift Autoscaling](#openshift-autoscaling)
  - [Source to Image builds](#source-to-image-builds)
  - [Source to Image builds, with webhook triggers for builds](#source-to-image-builds-with-webhook-triggers-for-builds)
  - [Build from template for two tier -- App Server and Backend](#build-from-template-for-two-tier----app-server-and-backend)
  - [Python (Django)  - PostgreSQL Backend](#python-django----postgresql-backend)
  - [ConfigMaps](#configmaps)
  - [Persistent Storage Using NFS - OCS](#persistent-storage-using-nfs---ocs)
  - [Pipelines](#pipelines)
  - [Operators](#operators)
  - [Code Ready Workspaces](#code-ready-workspaces)
  - [Resource Quotas and Limits](#resource-quotas-and-limits)
  - [Machine Learning](#machine-learning)
  - [Red Hat Service mesh](#red-hat-service-mesh)
  - [K-Native](#k-native)
- [Authors](#authors)

<!-- /TOC -->


### Installing OpenShift CLI v4.x
```
##Linux
curl -OL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-linux.tar.gz
tar -zxvf openshift-client-linux.tar.gz
mv oc /usr/local/bin
mv kubectl /usr/local/bin
chmod +x /usr/local/bin/oc
chmod +x /usr/local/bin/kubectl
oc version
kubectl version

##MAC
curl -OL https://mirror.openshift.com/pub/openshift-v4/clients/ocp/latest/openshift-client-mac-$VERSION.tar.gz
tar -zxvf openshift-client-mac-$VERSION.tar.gz
sudo mv oc /usr/local/bin
sudo mv kubectl /usr/local/bin
chmod +x /usr/local/bin/oc
chmod +x /usr/local/bin/kubectl
oc version
kubectl version
```


### Installing OpenShift CLI v3.11
```
##Linux
curl -OL https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
tar -zxvf openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit.tar.gz
sudo mv openshift-origin-client-tools-v3.11.0-0cbc58b-linux-64bit/oc /usr/local/bin
chmod +x /usr/local/bin/oc
oc version

##MAC
curl -OL https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-v3.11.0-0cbc58b-mac.zip
unzip openshift-origin-client-tools-v3.11.0-0cbc58b-mac.zip
sudo mv openshift-origin-client-tools-v3.11.0-0cbc58b-mac/oc /usr/local/bin
chmod +x /usr/local/bin/oc
oc version
```

### OpenShift Project Creation
```
oc new-project "example-project" \
  --description="Example  Description" \
  --display-name="example-project"
```

###  OpenShift User Creation
```
oc create user sample-user
```
### Update users password
```
htpasswd </path/to/users.htpasswd> sample-user
```
### Remove user from OpenShift
```
htpasswd -D </path/to/users.htpasswd> sample-user
```

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

### OpenShift Autoscaling
```
oc new-app https://github.com/sclorg/nodejs-ex
oc get pods  | grep nodejs
oc expose svc/nodejs-ex
oc autoscale dc/nodejs-ex --min 1 --max 5 --cpu-percent=10
oc set resources  dc/nodejs-ex --requests=cpu=200m,memory=256Mi --limits=cpu=400m,memory=512Mi

run siege
siege -r 3000 -c 50 http://urlendpoint
```

### Source to Image builds
[Source-to-Image Builders](https://github.com/tosin2013/openshift-demos/blob/master/source-to-image-demo.md)

### Source to Image builds, with webhook triggers for builds
[Source-to-Image Builders with web hooks](https://github.com/tosin2013/openshift-demos/blob/master/source-to-image-web-hooks-demo.md)

### Build from template for two tier -- App Server and Backend

### Python (Django)  - PostgreSQL Backend


### ConfigMaps
[Using ConfigMaps](https://github.com/tosin2013/openshift-demos/blob/master/configmaps.md)

### Persistent Storage Using NFS - OCS

### Pipelines
The following is a list of the pipeline samples available in container-pipelines repository:

* [Basic Tomcat](https://github.com/redhat-cop/container-pipelines/tree/master/basic-tomcat) - Builds a Java Application like Ticket Monster and deploys it to Tomcat
* [Basic Spring Boot](https://github.com/redhat-cop/container-pipelines/tree/master/basic-spring-boot) - Builds a Spring Boot application and deploys using an Embedded Servlet jar file
* [Blue Green Spring Boot](https://github.com/redhat-cop/container-pipelines/tree/master/blue-green-spring) - Build a Spring Boot application and deploys it using a blue-green deployment
* [Secure Spring Boot](https://github.com/redhat-cop/container-pipelines/tree/master/secure-spring-boot) - Build a Spring Boot app and deploy with a pipeline that includes code coverage reports, dependency scanning, sonarqube analysis
* [Cross Cluster Promotion Pipeline](https://github.com/redhat-cop/container-pipelines/tree/master/multi-cluster-spring-boot) - A declarative syntax pipeline that demonstrates promoting a microservice between clusters (i.e. a Non-Production to a Production cluster)

**Link:** [https://github.com/redhat-cop/container-pipelines](https://github.com/redhat-cop/container-pipelines)

### Operators
[Openshift Operators](https://github.com/tosin2013/openshift-demos/blob/master/operators/README.md)

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

### Resource Quotas and Limits
[Resource Quotas and Limits](openshift-features/quotas-limits.md)  

### Machine Learning
[MLFlow Tracking Server Operator](https://github.com/zmhassan/mlflow-tracking-operator)  
[mlflow-example](https://github.com/zmhassan/mlflow-example)  

### Red Hat Service mesh
[Service Mesh  Deployment On OCP4](istio/deploying-isitio-bookinfo-app-on-openshift-4.2.md)  
[Deploying Istio bookinfo app on OpenShift 4.2](istio/deploying-isitio-bookinfo-app-on-openshift-4.2.md)  

### K-Native
[Deploy Serverless Applications on Openshift 4.2](serverless/deploy-serverless-applications-on-openshift-4.2.md)  
[Knative CLI Demo On OpenShift 4.2](serverless/knative-cli-demo-on-openshift-4.2.md)  
[Knative Tutorial](https://redhat-developer-demos.github.io/knative-tutorial/knative-tutorial/1.0-SNAPSHOT/index.html)  
[Compile Driver](https://developers.redhat.com/coderland/serverless/)
[Knative + Kafka + Quarkus demo.](https://github.com/burrsutter/knative-kafka)


## Videos
*Knative + Kafka + Quarkus demo.*  
[![Alt text](http://i3.ytimg.com/vi/y3r78FX6U3E/maxresdefault.jpg)](https://www.youtube.com/watch?v=y3r78FX6U3E)
[Knative + Kafka + Quarkus demo.](https://github.com/burrsutter/knative-kafka)  

# Authors

* **Tosin Akinosho** - *Initial work* - [tosin2013](https://github.com/tosin2013)
