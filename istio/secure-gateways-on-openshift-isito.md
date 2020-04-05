# Secure Gateways (File Mount) On OpenShift Isito 

### Requirements 
* mtls is enabled in service mesh cluster.

### Comfirmation 
When secure routing is enabled in the isito cluster you will display a lock in the top right hand corner  of your Kilai dashboard.

![](https://i.imgur.com/3OKIp9L.png)


### Set DOMAIN
```
export BASE_DOMAIN="apps.ocp.example.com"
```

### Create a root certificate and private key to sign the certificate for your services
```
$ openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:2048 -subj '/O=example Inc./CN=${BASE_DOMAIN}' -keyout ${BASE_DOMAIN}.key -out ${BASE_DOMAIN}.crt
```

### Create a certificate and a private key for *.apps.ocp.example.com
```
$ openssl req -out *.${BASE_DOMAIN}.csr -newkey rsa:2048 -nodes -keyout *.${BASE_DOMAIN}.key -subj "/CN=helloworld.${BASE_DOMAIN}/O=helloworld organization"
$ openssl x509 -req -days 365 -CA ${BASE_DOMAIN}.crt -CAkey ${BASE_DOMAIN}.key -set_serial 0 -in *.${BASE_DOMAIN}.csr -out *.${BASE_DOMAIN}.crt
```

```
$ oc create -n istio-system secret tls istio-ingressgateway-certs --key *.${BASE_DOMAIN}.key --cert *.${BASE_DOMAIN}.crt
```

### Verify Certs have been mounted to isitio gateway.
```
$ oc exec -it -n istio-system $(oc -n istio-system get pods -l istio=ingressgateway -o jsonpath='{.items[0].metadata.name}') -- ls -al /etc/istio/ingressgateway-certs
total 0
drwxrwsrwt. 3 root 1000550000 120 Apr  4 23:50 .
drwxr-xr-x. 1 root root        78 Apr  4 22:28 ..
drwxr-sr-x. 2 root 1000550000  80 Apr  4 23:50 ..2020_04_04_23_50_12.674920212
lrwxrwxrwx. 1 root 1000550000  31 Apr  4 23:50 ..data -> ..2020_04_04_23_50_12.674920212
lrwxrwxrwx. 1 root 1000550000  14 Apr  4 23:50 tls.crt -> ..data/tls.crt
lrwxrwxrwx. 1 root 1000550000  14 Apr  4 23:50 tls.key -> ..data/tls.key
```

### Create Sample helloworld application 
```
$ cat helloworld.yaml 
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

### Create Secure Gateway and virtual service 
```
cat helloword-secure-gateway.yml
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: helloworld-gateway
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
      mode: SIMPLE
      serverCertificate: /etc/istio/ingressgateway-certs/tls.crt
      privateKey: /etc/istio/ingressgateway-certs/tls.key 
    hosts:
      - "*.${BASE_DOMAIN}"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: helloworld
spec:
  hosts:
  - "*.${BASE_DOMAIN}"
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

### Create Secure Route
```
$ oc create  route passthrough helloworld --service=istio-ingressgateway  --insecure-policy=Redirect --port https  -n istio-system
```

### Get Endpoint
```
GATEWAY=$(oc get route -n istio-system | grep helloworld | awk '{print $2}')
```

### Test Endpoint 
```
$ curl -k https://${GATEWAY}/hello
Hello version: v2, instance: helloworld-v2-7cdb9c6c8c-fkhsq
```