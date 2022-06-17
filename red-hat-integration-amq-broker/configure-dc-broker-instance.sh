#!/bin/bash

if [ ! -d $HOME/applications ]; then
  echo "Please download the applications to $HOME/applications"
  echo "See:
  Set up the main configuration Application for Red Hat Advanced Cluster Management -> https://hackmd.io/rKGcWPITQj6EjOE0IlCP8Q
  OpenShift Post Installation with Red Hat Advanced Cluster Management for Kubernetes -> https://github.com/redhat-gpte-devopsautomation/ilt-applications
  "
  exit 1 
fi

mkdir -p $HOME/applications/managed/dc-broker
mkdir -p $HOME/applications/managed/dc-broker/base
touch $HOME/applications/managed/dc-broker/base/kustomization.yaml
mkdir -p $HOME/applications/managed/dc-broker/overlays
mkdir -p $HOME/applications/managed/dc-broker/overlays/sno
mkdir -p $HOME/applications/managed/dc-broker/overlays/converged
mkdir -p $HOME/applications/managed/dc-broker/overlays/local-cluster
cd $HOME/applications/managed/dc-broker/
tree .

curl -o $HOME/applications/managed/dc-broker/overlays/local-cluster/kustomization.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/kustomization.yaml
curl -o $HOME/applications/managed/dc-broker/overlays/local-cluster/dc-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-dc-broker.yaml
kustomize build $HOME/applications/managed/dc-broker/overlays/local-cluster


curl -o $HOME/applications/managed/dc-broker/overlays/converged/kustomization.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/kustomization.yaml
curl -o $HOME/applications/managed/dc-broker/overlays/converged/dc-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-dc-broker.yaml
kustomize build $HOME/applications/managed/dc-broker/overlays/converged

curl -o $HOME/applications/managed/dc-broker/overlays/sno/kustomization.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/kustomization.yaml
curl -o $HOME/applications/managed/dc-broker/overlays/sno/dc-broker.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-dc-broker.yaml
kustomize build $HOME/applications/managed/dc-broker/overlays/sno

cd $HOME/applications
git add -A

git commit -m "Added Red Hat Integration - AMQ Broker Instance installed"

git push

mkdir -p $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/local-cluster
cd $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/local-cluster
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/local-cluster/placementrule.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-placementrule.yaml
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/local-cluster/subscription.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-subscription.yaml
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/local-cluster/application.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/local-cluster-application.yaml


mkdir -p $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/sno
cd $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/sno
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/sno/placementrule.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-placementrule.yaml
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/sno/subscription.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-subscription.yaml
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/sno/application.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/sno-application.yaml

mkdir -p $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/converged
cd $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/converged
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/converged/placementrule.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-placementrule.yaml
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/converged/subscription.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-subscription.yaml
curl -o $HOME/rhacm-configuration/rhacm-root/subscriptions/dc-broker/converged/application.yaml https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/yamls/converged-application.yaml

cd $HOME/rhacm-configuration
git add -A

git commit -m "Added Red Hat Integration - AMQ Broker Instance subscriptions"

git push