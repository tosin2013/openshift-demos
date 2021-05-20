# Deploy Serverless Applications on Openshift 4.7

## Install the OpenShift Serverless operator
1. Log in to the OpenShift Container Platform web console.
2. Navigate to Operators → OperatorHub.
3. Type `OpenShift Serverless` into the filter box to locate the [Red Hat OpenShift Serverless Operator](https://docs.openshift.com/container-platform/4.7/serverless/admin_guide/installing-openshift-serverless.html#installing-openshift-serverless).
4. Click the **OpenShift Serverless Operator** to display information about the Operator.
5. Click Install.
6. On the Create Operator Subscription page, select All namespaces on the cluster (default). This installs the Operator in the default openshift-operators project and makes the Operator available to all projects in the cluster.
7. Select the `stable` Update Channel.
8. Select the Automatic Approval Strategy.
9. The Manual approval strategy requires a user with appropriate credentials to approve the Operator install and subscription process.
10. Click Subscribe.
11. The Subscription Overview page displays the OpenShift Serverless Operator’s installation progress.

Wait for all operators to be installed
```
$  oc get csv
NAME                          DISPLAY                        VERSION   REPLACES                      PHASE
serverless-operator.v1.14.0   Red Hat OpenShift Serverless   1.14.0    serverless-operator.v1.13.0   Succeeded
```

Create the [knative-servering](https://docs.openshift.com/container-platform/4.7/serverless/admin_guide/installing-knative-serving.html#installing-knative-serving) namespace
```
cat >serving.yaml<<EOF
apiVersion: operator.knative.dev/v1alpha1
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
$ oc get knativeserving.operator.knative.dev/knative-serving -n knative-serving --template='{{range .status.conditions}}{{printf "%s=%s\n" .type .status}}{{end}}'
```

When status returns the following installation is complete
```
DependenciesInstalled=True
DeploymentsAvailable=True
InstallSucceeded=True
Ready=True
```

Verify Pods has started
```
$  oc get pods -n knative-serving
NAME                                                     READY   STATUS      RESTARTS   AGE
activator-58fb6669f6-2txpm                               2/2     Running     0          5m21s
activator-58fb6669f6-9zxw4                               2/2     Running     0          5m6s
autoscaler-769678c97d-26thw                              2/2     Running     0          5m20s
autoscaler-hpa-cd895c4bf-shqpb                           2/2     Running     0          5m18s
autoscaler-hpa-cd895c4bf-xl8l7                           2/2     Running     0          5m18s
controller-767dbc779c-h9thc                              2/2     Running     0          5m3s
controller-767dbc779c-zbxdm                              2/2     Running     0          5m13s
domain-mapping-6655558fc4-4mgj6                          2/2     Running     0          5m17s
domainmapping-webhook-7d8b776b4-9k46w                    2/2     Running     0          5m17s
storage-version-migration-serving-serving-0.20.0-x7754   0/1     Completed   0          5m16s
webhook-576b57b4d6-kbqmc                                 2/2     Running     0          5m5s
webhook-576b57b4d6-kf5fp                                 2/2     Running     0          5m19s
```

## Links:
[OpenShift Serverless product architecture](https://docs.openshift.com/container-platform/4.2/serverless/serverless-architecture.html)  
[Scaling a MachineSet manually](https://docs.openshift.com/container-platform/4.2/serverless/installing-openshift-serverless.html#machineset-manually-scaling_installing-openshift-serverless)  
[Getting started with Knative services](https://docs.openshift.com/container-platform/4.2/serverless/getting-started-knative-services.html)  
[Monitoring OpenShift Serverless components](https://docs.openshift.com/container-platform/4.2/serverless/monitoring-serverless.html)  
[Using metering with OpenShift Serverless](https://docs.openshift.com/container-platform/4.2/serverless/serverless-metering.html)  
[Cluster logging with OpenShift Serverless](https://docs.openshift.com/container-platform/4.2/serverless/cluster-logging-serverless.html)  
[Configuring Knative Serving autoscaling](https://docs.openshift.com/container-platform/4.2/serverless/configuring-knative-serving-autoscaling.html)  
