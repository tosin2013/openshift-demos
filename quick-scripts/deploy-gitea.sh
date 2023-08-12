#!/bin/bash


function wait-for-me(){
    while [[ $(oc get pods $1  -n openshift-operators -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
        sleep 1
    done

}

oc apply -k https://github.com/rhpds/gitea-operator/OLMDeploy
echo "Sleep for 60 seconds..."
sleep 60s

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
oc apply -f deploy-gitea.yaml -n gitea
