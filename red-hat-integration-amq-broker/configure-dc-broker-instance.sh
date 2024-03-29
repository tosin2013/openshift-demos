#!/bin/bash
set -xe 

if [ ! -d $HOME/applications ]; then
  echo "Please download the applications to $HOME/applications"
  echo "See:
  Set up the main configuration Application for Red Hat Advanced Cluster Management -> https://hackmd.io/rKGcWPITQj6EjOE0IlCP8Q
  OpenShift Post Installation with Red Hat Advanced Cluster Management for Kubernetes -> https://github.com/redhat-gpte-devopsautomation/ilt-applications
  "
  exit 1 
fi

mkdir -p $HOME/applications/managed/amq-broker
mkdir -p $HOME/applications/managed/amq-broker/base
touch $HOME/applications/managed/amq-broker/base/kustomization.yaml
mkdir -p $HOME/applications/managed/amq-broker/overlays
mkdir -p $HOME/applications/managed/amq-broker/overlays/sno
mkdir -p $HOME/applications/managed/amq-broker/overlays/converged
mkdir -p $HOME/applications/managed/amq-broker/overlays/local-cluster
cd $HOME/applications/managed/amq-broker/
tree .

curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/kustomization.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/kustomization.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/amq-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-amq-broker.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/amq-address.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/amq-address.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/IoT.simulator.configmap.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.configmap.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/IoT.simulator.role.binding.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.role.binding.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/IoT.simulator.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/clusterrole.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/clusterrole.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/clusterrolebinding.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/clusterrolebinding.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/local-cluster/service-monitor.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/service-monitor-local-cluster.yaml
tree  $HOME/applications/managed/amq-broker/overlays/local-cluster
sleep 3s
kustomize build $HOME/applications/managed/amq-broker/overlays/local-cluster


curl -o  $HOME/applications/managed/amq-broker/overlays/converged/kustomization.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/kustomization.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/amq-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-amq-broker.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/amq-address.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/amq-address.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/IoT.simulator.configmap.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.configmap.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/IoT.simulator.role.binding.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.role.binding.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/IoT.simulator.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/clusterrole.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/clusterrole.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/clusterrolebinding.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/clusterrolebinding.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/converged/service-monitor.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/service-monitor.yaml
tree  $HOME/applications/managed/amq-broker/overlays/converged
sleep 3s
kustomize build $HOME/applications/managed/amq-broker/overlays/converged

curl -o  $HOME/applications/managed/amq-broker/overlays/sno/kustomization.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/kustomization.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/amq-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-amq-broker.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/amq-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-amq-broker.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/amq-address.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/amq-address.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/IoT.simulator.configmap.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.configmap.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/IoT.simulator.role.binding.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.role.binding.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/IoT.simulator.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/IoT.simulator.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/clusterrole.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/clusterrole.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/clusterrolebinding.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/clusterrolebinding.yaml
curl -o  $HOME/applications/managed/amq-broker/overlays/sno/service-monitor.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/application/service-monitor.yaml
tree  $HOME/applications/managed/amq-broker/overlays/sno
sleep 3s
kustomize build $HOME/applications/managed/amq-broker/overlays/sno

cd $HOME/applications
git add -A

git commit -m "Added Red Hat Integration - AMQ Broker Instance installed"

git push

mkdir -p $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/local-cluster
cd $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/local-cluster
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/local-cluster/placementrule.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-placementrule.yaml
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/local-cluster/subscription.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-subscription.yaml
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/local-cluster/application.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-application.yaml
tree  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/local-cluster
sleep 3s

mkdir -p $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/sno
cd $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/sno
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/sno/placementrule.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-placementrule.yaml
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/sno/subscription.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-subscription.yaml
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/sno/application.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-application.yaml
tree  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/sno
sleep 3s

mkdir -p $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/converged
cd $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/converged
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/converged/placementrule.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-placementrule.yaml
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/converged/subscription.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-subscription.yaml
curl -o  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/converged/application.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-application.yaml
tree  $HOME/rhacm-configuration/rhacm-root/subscriptions/amq-broker/converged
sleep 3s

cd $HOME/rhacm-configuration
git add -A

git commit -m "Added Red Hat Integration - AMQ Broker Instance subscriptions"

git push