# Deploy the Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) Operator to managed clusters 

## Getting Started 
### Requirements
[Set up the main configuration Application for Red Hat Advanced Cluster Management](https://hackmd.io/rKGcWPITQj6EjOE0IlCP8Q)

## Screen Shots
![20220617151949](https://i.imgur.com/CZGdJNG.png)
**local-cluster-dc-broker-development**
![20220617151920](https://i.imgur.com/f2Yf6UV.png)

**sno-dc-broker-development**
![20220617151553](https://i.imgur.com/GdLFxD1.png)

###  Deploy Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) on Hub Cluster
**Create a new directory to hold the policy:**

```bash
mkdir -p $HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker 

cd $HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker 
```

**Create a policy openshift-amq-broker  in namespace acm-policies that creates all the
required objects for the Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) Operator.**

```bash
cat << EOF >$HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker/policy.yaml
---
apiVersion: policy.open-cluster-management.io/v1
kind: Policy
metadata:
  name: policy-amq-broker-rhel8
  namespace: acm-policies
  annotations:
    policy.open-cluster-management.io/standards: null
    policy.open-cluster-management.io/categories: null
    policy.open-cluster-management.io/controls: null
spec:
  remediationAction: enforce
  disabled: false
  policy-templates:
    - objectDefinition:
        apiVersion: policy.open-cluster-management.io/v1
        kind: ConfigurationPolicy
        metadata:
          name: amq-broker-rhel8-operator-ns
        spec:
          remediationAction: enforce
          severity: high
          object-templates:
            - complianceType: musthave
              objectDefinition:
                apiVersion: v1
                kind: Namespace
                metadata:
                  name: demo-amq-dc
    - objectDefinition:
        apiVersion: policy.open-cluster-management.io/v1
        kind: ConfigurationPolicy
        metadata:
          name: amq-broker-rhel8-operator-subscription
        spec:
          remediationAction: inform
          severity: high
          object-templates:
            - complianceType: musthave
              objectDefinition:
                apiVersion: operators.coreos.com/v1alpha1
                kind: Subscription
                metadata:
                  name: amq-broker-rhel8
                  namespace:  demo-amq-dc
                spec:
                  installPlanApproval: Automatic
                  name: amq-broker-rhel8
                  source: redhat-operators
                  sourceNamespace: openshift-marketplace
EOF
```

**Create a placement rule named openshift-amq-broker  to deploy to local cluster.**

```bash
cat << EOF >$HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker/placementrule.yaml
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: placement-policy-amq-broker-rhel8
  namespace: acm-policies
spec:
  clusterConditions:
    - status: 'True'
      type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions:
      - key: local-cluster
        operator: In
        values:
          - 'true'
EOF
```

**Create a Placement Binding openshift-amq-broker  to place this policy on all OpenShift managed clusters.**

```bash
cat << EOF >$HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker/placementbinding.yaml
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
  name: binding-policy-amq-broker-rhel8
  namespace: acm-policies
placementRef:
  name: placement-policy-amq-broker-rhel8
  kind: PlacementRule
  apiGroup: apps.open-cluster-management.io
subjects:
  - name: policy-amq-broker-rhel8
    kind: Policy
    apiGroup: policy.open-cluster-management.io
EOF
```

**Add, commit and push the files to the repository.**

```bash
cd $HOME/rhacm-configuration
git add -A

git commit -m "Added Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) installed policy"

git push
```

###  Deploy Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) managed clusters
**Create a new directory to hold the policy:**

```bash
mkdir -p $HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker-managed
cd $HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker-managed
```
#### WIP unable to gifure out name variable for project
**Create a policy openshift-amq-broker  in namespace acm-policies that creates all the
required objects for the Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) Operator.**

```bash
cat << EOF >$HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker-managed/policy.yaml
---
apiVersion: policy.open-cluster-management.io/v1
kind: Policy
metadata:
  name: policy-amq-broker-rhel8-managed
  namespace: acm-policies
  annotations:
    policy.open-cluster-management.io/standards: null
    policy.open-cluster-management.io/categories: null
    policy.open-cluster-management.io/controls: null
spec:
  remediationAction: enforce
  disabled: false
  policy-templates:
    - objectDefinition:
        apiVersion: policy.open-cluster-management.io/v1
        kind: ConfigurationPolicy
        metadata:
          name: amq-broker-rhel8-operator-pkgc-ns
        spec:
          remediationAction: enforce
          severity: high
          object-templates:
            - complianceType: musthave
              objectDefinition:
                apiVersion: v1
                kind: Namespace
                metadata:
                  name: demo-amq-pkgc
    - objectDefinition:
        apiVersion: policy.open-cluster-management.io/v1
        kind: ConfigurationPolicy
        metadata:
          name: amq-broker-rhel8-operator-pkgc-subscription
        spec:
          remediationAction: inform
          severity: high
          object-templates:
            - complianceType: musthave
              objectDefinition:
                apiVersion: operators.coreos.com/v1alpha1
                kind: Subscription
                metadata:
                  name: amq-broker-rhel8
                  namespace: demo-amq-pkgc
                spec:
                  installPlanApproval: Automatic
                  name: amq-broker-rhel8
                  source: redhat-operators
                  sourceNamespace: openshift-marketplace
EOF
```

**Create a placement rule named openshift-amq-broker  to select all OpenShift clusterswith either label purpose=development or purpose=production.**

```bash
cat << EOF >$HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker-managed/placementrule.yaml
---
apiVersion: apps.open-cluster-management.io/v1
kind: PlacementRule
metadata:
  name: placement-policy-amq-broker-rhel8-managed
  namespace: acm-policies
spec:
  clusterConditions:
    - status: 'True'
      type: ManagedClusterConditionAvailable
  clusterSelector:
    matchExpressions:
      - key: deploymentype
        operator: In
        values:
          - sno
          - converged
EOF
```

**Create a Placement Binding openshift-amq-broker  to place this policy on all OpenShift managed clusters.**

```bash
cat << EOF >$HOME/rhacm-configuration/rhacm-root/policies/openshift-amq-broker-managed/placementbinding.yaml
---
apiVersion: policy.open-cluster-management.io/v1
kind: PlacementBinding
metadata:
  name: binding-policy-amq-broker-rhel8-managed
  namespace: acm-policies
placementRef:
  name: placement-policy-amq-broker-rhel8-managed
  kind: PlacementRule
  apiGroup: apps.open-cluster-management.io
subjects:
  - name: policy-amq-broker-rhel8-managed
    kind: Policy
    apiGroup: policy.open-cluster-management.io
EOF
```

**Add, commit and push the files to the repository.**

```bash
cd $HOME/rhacm-configuration
git add -A

git commit -m "Added Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) installed policy"

git push
```

###  Deploy ActiveMQArtemis managed clusters
**Git clone**
```bash 
git clone https://gitea-with-admin-gitea.apps.ocp4.examqle.com/user1/applications.git
cd applications
```

**Run the configure-dc-broker-instance.sh :**
> if you are running on linux box run the script below 
```bash
curl -OL https://raw.githubusercontent.com/tosin2013/openshift-demos/master/red-hat-integration-amq-broker/configure-dc-broker-instance.sh
./configure-dc-broker-instance.sh
```
> if you are manually creating the files review the script and url 
* https://github.com/tosin2013/openshift-demos/blob/master/red-hat-integration-amq-broker/configure-dc-broker-instance.sh
* https://github.com/tosin2013/openshift-demos/tree/master/red-hat-integration-amq-broker/yamls

