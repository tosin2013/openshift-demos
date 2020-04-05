# Service Mesh  Deployment On OCP4

## Requirements
Install OpenShift 4

## Required Operators
Elasticsearch - Based on the open source Elasticsearch project that enables you to configure and manage an Elasticsearch cluster for tracing and logging with Jaeger.

Jaeger - based on the open source Jaeger project, lets you perform tracing to monitor and troubleshoot transactions in complex distributed systems.

Kiali - based on the open source Kiali project, provides observability for your service mesh. By using Kiali you can view configurations, monitor traffic, and view and analyze traces in a single console.

## Install Required Operators from OperatorHub
### Elasticsearch Operator
1. Log in to the OpenShift Container Platform web console.
2. Navigate to Operators → OperatorHub.
3. Type **Elasticsearch** into the filter box to locate the Elasticsearch Operator.
4. Click the Elasticsearch Operator to display information about the Operator.
5. Click Install.
6. On the Create Operator Subscription page, select All namespaces on the cluster (default). This installs the Operator in the default openshift-operators project and makes the Operator available to all projects in the cluster.
7. Select the *preview* Update Channel.
8. Select the Automatic Approval Strategy.
9. The Manual approval strategy requires a user with appropriate credentials to approve the Operator install and subscription process.
10. Click Subscribe.
11. The Subscription Overview page displays the Elasticsearch Operator’s installation progress.


### Jaeger Operator
1. Log in to the OpenShift Container Platform web console.
2. Navigate to Operators → OperatorHub.
3. Type **Jaeger** into the filter box to locate the Jaeger Operator.
4. Click the Jaeger Operator provided by Red Hat to display information about the Operator.
5. Click Install.
6. On the Create Operator Subscription page, select All namespaces on the cluster (default). This installs the Operator in the default openshift-operators project and makes the Operator available to all projects in the cluster.
7. Select the *stable* Update Channel.
8. Select the Automatic Approval Strategy.
9. The Manual approval strategy requires a user with appropriate credentials to approve the Operator install and subscription process.
10. Click Subscribe.
11. The Subscription Overview page displays the Jaeger Operator’s installation progress.

### Kiali Operator
1. Log in to the OpenShift Container Platform web console.
2. Navigate to Operators → OperatorHub.
3. Type **Kiali** into the filter box to find the Kiali Operator.
4. Click the Kiali Operator provided by Red Hat to display information about the Operator.
5. Click Install.
6. On the Create Operator Subscription page, select All namespaces on the cluster (default). This installs the Operator in the default openshift-operators project and makes the Operator available to all projects in the cluster.
7. Select the *stable* Update Channel.
8. Select the Automatic Approval Strategy.

### Install the Red Hat OpenShift Service Mesh Operator
**Prerequisites**
* Access to the OpenShift Container Platform web console.
* The Elasticsearch Operator must be installed.
* The Jaeger Operator must be installed next.
* Finally  Kiali Operator must be installed.

**Process**
1. Log in to the OpenShift Container Platform web console.
2.  Navigate to Operators → OperatorHub.
3.  Type **Red Hat OpenShift Service Mesh** into the filter box to find the Red Hat OpenShift Service Mesh Operator.
4.   Click the Red Hat OpenShift Service Mesh Operator to display information a bout the Operator.
5.   On the Create Operator Subscription page, select All namespaces on the cluster (default). This installs the Operator in the default openshift-operators project and makes the Operator available to all projects in the cluster.
6.    Click Install.
7.    Select the 1.0 Update Channel.
8.    Select the Automatic Approval Strategy.

### Deploy the control plane
**You must be an cluster admin to perform the commands below.**

Login to OpenShift
```
$ oc login https://{HOSTNAME}:8443
```

Create a new project named istio-system.
```
$ oc new-project istio-system
```

Example istio-installation.yaml  
*set mtls: to  true to enable*
```
vim istio-installation.yaml

apiVersion: maistra.io/v1
kind: ServiceMeshControlPlane
metadata:
  name: full-install
spec:

  istio:
    global:
      proxy:
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 128Mi
      mtls:
        enabled: false

    gateways:
      istio-egressgateway:
        autoscaleEnabled: false
      istio-ingressgateway:
        autoscaleEnabled: false

    mixer:
      policy:
        autoscaleEnabled: false

      telemetry:
        autoscaleEnabled: false
        resources:
          requests:
            cpu: 100m
            memory: 1G
          limits:
            cpu: 500m
            memory: 4G

    pilot:
      autoscaleEnabled: false
      traceSampling: 100

    kiali:
      enabled: true

    grafana:
      enabled: true

    tracing:
      enabled: true
      jaeger:
        template: all-in-one

```
*Note that for production use you must change the default Jaeger template.*

Run the following command to deploy the control plane:
```
$ oc create -n istio-system -f istio-installation.yaml
```

Get the status of the control plane installation.
```
$ oc get smcp -n istio-system
```

Get the progress of the Pods during the installation process:
```
$ oc get pods -n istio-system -w
```

Create Project that you will use for ServiceMesh
```
oc new-project my-service-mesh
```

Create a member role for ServiceMesh.
*Without this projects an applications will not have access to ServiceMesh and its functionaility.*

Example servicemeshmemberroll.yaml
```
vim  servicemeshmemberroll.yaml

apiVersion: maistra.io/v1
kind: ServiceMeshMemberRoll
metadata:
  name: default
  namespace: istio-system
spec:
  members:
    - my-service-mesh
```

Create a ServiceMeshMemberRoll resource in the same project as the ServiceMeshControlPlane resource.
```
oc create -n istio-system -f servicemeshmemberroll.yaml
```

### Links:
[Offical Documentation](https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_install/installing-ossm.html)
