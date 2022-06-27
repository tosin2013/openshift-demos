# Enabling monitoring for user-defined projects with RHACM Integration

## Clone repo 
```
https://github.com/tosin2013/openshift-demos.git
```

## cd into openshift-demos/workload-monitoring-for-user-defined-projects
```
cd openshift-demos/workload-monitoring-for-user-defined-projects
```

## Enable user workload monitoring
```
oc create -f - <<EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: cluster-monitoring-config
  namespace: openshift-monitoring
data:
  config.yaml: |
    enableUserWorkload: true
EOF
```

##  Check the user workload monitoring status
```
oc get pods -n openshift-user-workload-monitoring
```

## To grant user permissions for monitoring user defined projects

[Granting users permission to monitor user-defined projects](https://docs.openshift.com/container-platform/latest/monitoring/enabling-monitoring-for-user-defined-projects.html#granting-users-permission-to-monitor-user-defined-projects_enabling-monitoring-for-user-defined-projects)

## Deploy sample Application
```
oc create -k deploy
```

### View metrics on OpenShift Cluster 
![20220627123755](https://i.imgur.com/VCvZTGt.png)

# To create custom dashboards in Grafana using ACM
* [Red Hat Advanced Cluster Management for Kubernetes](https://www.redhat.com/en/technologies/management/advanced-cluster-management)
* [Product Documentation for Red Hat Advanced Cluster Management for Kubernetes 2.5](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.5)

### Login to ACM hub cluster with Observability operator installed
[Observing environments introduction](https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.5/html/observability/observing-environments-intro)

### Create observability-metrics-custom-allowlist.yaml
> This will allow metrics to populate for each application metric
```
cat >observability-metrics-custom-allowlist.yaml<<YAML
kind: ConfigMap
apiVersion: v1
metadata:
  name: observability-metrics-custom-allowlist
data:
  metrics_list.yaml: |
    names:
      - nginx_http_requests_total
      - nginx_up
      - nginx_connections_active
      - nginxexporter_build_info
      - nginx_connections_handled
      - nginx_connections_reading
      - nginx_connections_waiting
      - nginx_connections_writing
      - nginx_http_requests_total
      - nginx_connections_accepted
YAML
```

### Apply config map against RHACM
```
oc apply -n open-cluster-management-observability -f observability-metrics-custom-allowlist.yaml
```

## To create custom dashboard for Application metrics 
[How to design a grafana dashboard](https://github.com/open-cluster-management/multicluster-observability-operator/tree/main/tools)

## View Metrics on RHACM
> login using the https://multicloud-console.apps.cluster.example.com/grafana-dev/ url
![20220627123113](https://i.imgur.com/WH1QqSl.png)