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
mkdir -p $HOME/applications/managed/dc-broker/overlays
mkdir -p $HOME/applications/managed/dc-broker/overlays/sno
mkdir -p $HOME/applications/managed/dc-broker/overlays/converged
mkdir -p $HOME/applications/managed/dc-broker/overlays/local-cluster
cd $HOME/applications/managed/dc-broker/
tree .
cat > $HOME/applications/managed/dc-broker/base/kustomization.yaml<<EOF
EOF
curl -o target/path/filename URL