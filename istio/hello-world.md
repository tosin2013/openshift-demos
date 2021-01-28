```
apiVersion: v1
kind: Service
metadata:
  name: helloworld
  labels:
    app: helloworld
spec:
  ports:
  - port: 5000
    name: http
  selector:
    app: helloworld
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-v1
  labels:
    version: v1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: helloworld
      version: v1
  template:
    metadata:
      labels:
        app: helloworld
        version: v1
      annotations:
        sidecar.istio.io/inject: "true"  
    spec:
      containers:
      - name: helloworld
        image: docker.io/istio/examples-helloworld-v1
        resources:
          requests:
            cpu: "100m"
        imagePullPolicy: IfNotPresent #Always
        ports:
        - containerPort: 5000
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: helloworld-v2
  labels:
    version: v2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: helloworld
      version: v2
  template:
    metadata:
      labels:
        app: helloworld
        version: v2
      annotations:
        sidecar.istio.io/inject: "true"
    spec:
      containers:
      - name: helloworld
        image: docker.io/istio/examples-helloworld-v2
        resources:
          requests:
            cpu: "100m"
        imagePullPolicy: IfNotPresent #Always
        ports:
        - containerPort: 5000
```

Secure Gateway
```
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: helloworld-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
     mode: SIMPLE
     secretName: hello-cert
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld
spec:
  hosts:
  - "*"
  gateways:
  - helloworld-gateway
  http:
  - match:
    - uri:
        exact: /hello
    route:
    - destination:
        host: helloworld
        port:
          number: 5000
```

Secure Route 

 oc create  route passthrough --service=istio-ingressgateway --hostname=tosin1 --insecure-policy=Redirect --port https  -n istio-system


```
kind: Route
apiVersion: route.openshift.io/v1
metadata:
  name: helloworld-ingressgateway
  namespace: istio-system
  selfLink: >-
    /apis/route.openshift.io/v1/namespaces/istio-system/routes/helloworld-ingressgateway
  uid: f871cd8c-5465-41b3-8736-15bc1d74ba95
  resourceVersion: '5007259'
  creationTimestamp: '2020-04-01T18:55:38Z'
  annotations:
    openshift.io/host.generated: 'true'
spec:
  host: helloworld-ingressgateway-istio-system.apps.ocp4.tosins-tower-demo.com
  to:
    kind: Service
    name: istio-ingressgateway
    weight: 100
  port:
    targetPort: https
  tls:
    termination: passthrough
    insecureEdgeTerminationPolicy: Redirect
  wildcardPolicy: None
status:
  ingress:
    - host: helloworld-ingressgateway-istio-system.apps.ocp4.tosins-tower-demo.com
      routerName: default
      conditions:
        - type: Admitted
          status: 'True'
          lastTransitionTime: '2020-04-01T18:55:38Z'
      wildcardPolicy: None
      routerCanonicalHostname: apps.ocp4.tosins-tower-demo.com

```