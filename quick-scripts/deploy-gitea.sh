#!/bin/bash


function wait-for-me(){
    while [[ $(oc get pods $1  -n openshift-operators -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
        sleep 1
    done

}

oc apply -k https://github.com/rhpds/gitea-operator/OLMDeploy


cat >gitea-catalog.yaml<<EOF
apiVersion: operators.coreos.com/v1alpha1
kind: Subscription
metadata:
  creationTimestamp: null
  labels:
    operators.coreos.com/gitea-operator.openshift-operators: ''
  name: gitea-operator
  namespace: openshift-operators
spec:
  channel: stable
  installPlanApproval: Automatic
  name: gitea-operator
  source: redhat-gpte-gitea
  sourceNamespace: openshift-marketplace
EOF
oc apply -f gitea-catalog.yaml

sleep 30s

PODNAME=$(oc get pods -n gitea-operator | grep gitea-operator-controller-manager- | awk '{print $1}')
wait-for-me $PODNAME

oc new-project gitea


cat >deploy-gitea.yaml<<EOF
apiVersion: pfe.rhpds.com/v1
kind: Gitea
metadata:
  name: gitea-with-admin
spec:
  giteaSsl: true
  giteaAdminUser: opentlc-mgr
  giteaAdminPassword: ""
  giteaAdminPasswordLength: 32
  giteaAdminEmail: opentlc-mgr@redhat.com
  giteaCreateUsers: true
  giteaGenerateUserFormat: lab-user
  giteaUserNumber: 1
  giteaUserPasswordLength: 16
EOF
oc apply -f deploy-gitea.yaml
