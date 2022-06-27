# Deploy the Red Hat Integration - AMQ Broker for RHEL 8 (Multiarch) Operator to managed clusters Metrics
![20220627111636](https://i.imgur.com/LPRFX6B.png)

# How to design a grafana dashboard on ACM
[How to design a grafana dashboard](https://github.com/stolostron/multicluster-observability-operator/tree/main/tools)

**Create Service Monitor**
```
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  labels:
    k8s-app: amq-broker-instance-pro
  name: amq-broker-instance-pro
  namespace: openshift-monitoring
spec:
  endpoints:
    - interval: 30s
      path: /metrics
      port: wconsj-0
      scheme: http
  namespaceSelector:
    matchNames:
      - demo-amq-dc
  selector: {}
```


**Create ClusterRoleBinding**
```
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name:  amq-broker-instance-pro
subjects:
  - kind: ServiceAccount
    name: prometheus-k8s
    namespace: openshift-monitoring
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name:  amq-broker-instance-pro
```

**Create Cluster Role for service**
```
kind: ClusterRole
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: amq-broker-instance-pro
rules:
  - verbs:
      - get
      - watch
      - list
    apiGroups:
      - ''
    resources:
      - pods
      - services
      - endpoints
 ```

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
      - artemis_number_of_pages
      - artemis_address_memory_usage
      - artemis_address_memory_usage_percentage
      - artemis_address_size
      - artemis_connection_count
      - artemis_consumer_count
      - artemis_delivering_durable_message_count
      - artemis_delivering_durable_persistent_size
      - artemis_delivering_message_count
      - artemis_delivering_persistent_size
      - artemis_disk_store_usage
      - artemis_durable_message_count
      - artemis_durable_persistent_size
      - artemis_message_count
      - artemis_messages_acknowledged
      - artemis_messages_added
      - artemis_messages_expired
      - artemis_messages_killed
      - artemis_number_of_pages
      - artemis_persistent_size
      - artemis_routed_message_count
      - artemis_scheduled_durable_message_count
      - artemis_scheduled_durable_persistent_size
      - artemis_scheduled_message_count
      - artemis_scheduled_persistent_size
      - artemis_total_connection_count
      - artemis_unrouted_message_count
      - jvm_buffer_count_buffers
      - jvm_buffer_memory_used_bytes
      - jvm_buffer_total_capacity_bytes
      - jvm_memory_committed_bytes
      - jvm_memory_max_bytes
      - jvm_memory_used_bytes
YAML
```

### Apply config map against RHACM
> WIP
```
oc apply -n open-cluster-management-observability -f observability-metrics-custom-allowlist.yaml
```



## Optional run load test
> Edit URL in script
```
./load_test.sh
```

## Test Query on OpenShift 
![20220627102256](https://i.imgur.com/vvfCV72.png)
```
artemis_durable_message_count{address="sampleaddress"}
```


## Test Query on RHACM
![20220627105303](https://i.imgur.com/OO0WX52.png)
```
artemis_durable_message_count{address="sampleaddress"}
```




