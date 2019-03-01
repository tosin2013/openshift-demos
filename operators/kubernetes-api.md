# Basic Operations with the Kubernetes API

**Start minishift cluster locally.**
```
./start_minishift.sh
```

**Switch to myproject.**
```
oc project myproject
```

**Create a manifest for a pod running to containers.**
```
PODNAME="changemyname"
cat > ${PODNAME}-multi-container.yaml <<EOF
apiVersion: v1
kind: Pod
metadata:
  name: ${PODNAME}-pod
  namespace: myproject
  labels:
    environment: dev
spec:
  containers:
    - name: server
      image: nginx:1.13-alpine
      ports:
        - containerPort: 80
          protocol: TCP
    - name: side-car
      image: alpine:latest
      command: ["/usr/bin/tail", "-f", "/dev/null"]
  restartPolicy: Never
EOF
```
**Deploy the pods.**
```
oc create -f ${PODNAME}-multi-container.yaml
```

**Check the status of the pods.**
```
oc get pods -w
```
**Examine the pod.**
```
oc describe pod ${PODNAME}-pod
```
**Execute a command in pod.**
```
oc exec -it ${PODNAME}-pod -c server -- hostname
```

**Use the oc proxy command to proxy local requests on port 8001 to the Kubernetes API.**
```
oc proxy --port=8001
```

**Now lets send a GET request to the kuberetes api (in a new tab)**
```
curl -X GET http://localhost:8001
```

**Send a GET request to list all pods in the environment.**
```
curl -X GET http://localhost:8001/api/v1/pods
```

**Use jq to parse name of each items from the pods api**
```
curl -X GET http://localhost:8001/api/v1/pods | jq .items[].metadata.name
```
**Send a GET request using curl to get your pod information.**
```
curl -X GET http://localhost:8001/api/v1/namespaces/myproject/pods/${PODNAME}-pod
```
**Send a DELETE request using curl to delete your pod.**
```
curl -X DELETE http://localhost:8001/api/v1/namespaces/myproject/pods/${PODNAME}-pod
```
**Watch your pod delete.**
```
oc get pods -w
```
**Optional: Delete Minishift Cluster**
```
./delete_minishift.sh
```

**Run the Kubernetes API Fundamentals Training on learn.openshift.com for in depth training.**  
[Kubernetes API Fundamentals](https://learn.openshift.com/operatorframework/k8s-api-fundamentals/)
