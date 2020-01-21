# Deploy Serverless Applications on Openshift 4.2

## Install the OpenShift Serverless operator
1. Log in to the OpenShift Container Platform web console.
2. Navigate to Operators → OperatorHub.
3. Type OpenShift Serverless into the filter box to locate the OpenShift Serverless Operator.
4. Click the **OpenShift Serverless Operator** to display information about the Operator.
5. Click Install.
6. On the Create Operator Subscription page, select All namespaces on the cluster (default). This installs the Operator in the default openshift-operators project and makes the Operator available to all projects in the cluster.
7. Select the techpreview Update Channel.
8. Select the Automatic Approval Strategy.
9. The Manual approval strategy requires a user with appropriate credentials to approve the Operator install and subscription process.
10. Click Subscribe.
11. The Subscription Overview page displays the OpenShift Serverless Operator’s installation progress.

Wait for all operators to be installed
```
$ oc get csv
NAME                                         DISPLAY                          VERSION               REPLACES                     PHASE
elasticsearch-operator.4.2.14-202001061701   Elasticsearch Operator           4.2.14-202001061701                                Succeeded
jaeger-operator.v1.13.1                      Jaeger Operator                  1.13.1                                             Succeeded
kiali-operator.v1.0.9                        Kiali Operator                   1.0.9                 kiali-operator.v1.0.8        Succeeded
serverless-operator.v1.3.0                   OpenShift Serverless Operator    1.3.0                 serverless-operator.v1.2.0   Succeeded
servicemeshoperator.v1.0.4                   Red Hat OpenShift Service Mesh   1.0.4                 servicemeshoperator.v1.0.3   Succeeded
```
Create the knative-servering namespace
```
cat >serving.yaml<<EOF
apiVersion: v1
kind: Namespace
metadata:
 name: knative-serving
---
apiVersion: serving.knative.dev/v1alpha1
kind: KnativeServing
metadata:
 name: knative-serving
 namespace: knative-serving
EOF
```

Apply the knative-serving namespace
```
$ oc apply -f serving.yaml
```

Verify the installation is complete by using the following command
```
$ oc get knativeserving/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'
```

When status returns the following installation is complete
```
DependenciesInstalled=True
DeploymentsAvailable=True
InstallSucceeded=True
Ready=True
```

## Links:
[OpenShift Serverless product architecture](https://docs.openshift.com/container-platform/4.2/serverless/serverless-architecture.html)
[Scaling a MachineSet manually](https://docs.openshift.com/container-platform/4.2/serverless/installing-openshift-serverless.html#machineset-manually-scaling_installing-openshift-serverless)
[Getting started with Knative services](https://docs.openshift.com/container-platform/4.2/serverless/getting-started-knative-services.html)
[Monitoring OpenShift Serverless components](https://docs.openshift.com/container-platform/4.2/serverless/monitoring-serverless.html)
[Using metering with OpenShift Serverless](https://docs.openshift.com/container-platform/4.2/serverless/serverless-metering.html)
[Cluster logging with OpenShift Serverless](https://docs.openshift.com/container-platform/4.2/serverless/cluster-logging-serverless.html)
[Configuring Knative Serving autoscaling](https://docs.openshift.com/container-platform/4.2/serverless/configuring-knative-serving-autoscaling.html)
