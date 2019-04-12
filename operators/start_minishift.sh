#!/bin/bash
# https://docs.okd.io/latest/minishift/using/basic-usage.html#basic-usage-overview

echo "Launching minishift"
minishift profile set operators
minishift config set cpus 4
# Works with 4096 
minishift config set memory 8192

minishift config set vm-driver virtualbox
minishift addon enable admin-user

minishift start || exit $?
eval $(minishift oc-env)
eval $(minishift docker-env)
echo "Logging in to OpenShift as a cluster administrator"
oc login -u system:admin || exit $?
oc get pods
oc whoami
oc login -u system:admin
oc get pods --all-namespaces
sleep 5s

echo "Allow Container Images to use root user (Not Recommended in Production)"
oc project myproject
oc create serviceaccount useroot
oc adm policy add-scc-to-user anyuid -z useroot
