# Deploying  Secure Istio bookinfo app on OpenShift 4

The Bookinfo application consists of the following microservices:
* The productpage microservice calls the details and reviews microservices to populate the page.
* The details microservice contains book information.
* The reviews microservice contains book reviews. It also calls the ratings microservice.
* The ratings microservice contains book ranking information that accompanies a book review.

There are three versions of the reviews microservice:

* Version v1 does not call the ratings Service.
* Version v2 calls the ratings Service and displays each rating as one to five black stars.
* Version v3 calls the ratings Service and displays each rating as one to five red stars.


**Create the bookinfo project.**
```
$ oc new-project bookinfo
```

$ oc adm policy add-scc-to-group privileged system:serviceaccounts:bookinfo
$ oc adm policy add-scc-to-group anyuid system:serviceaccounts:bookinfo

```
$ oc label namespace bookinfo istio-injection=enabled
```

**Add the bookinfo project to the ServiceMeshMemberRoll**
```
$ oc -n istio-system patch --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"bookinfo"'"]}]'
```

**Add destination rule for mtls**
```
apiVersion: "networking.istio.io/v1alpha3"
kind: "DestinationRule"
metadata:
  name: "default"
  namespace: bookinfo
spec:
  host: "*.local"
  trafficPolicy:
    tls:
      mode: ISTIO_MUTUAL
```

**Deploy the Bookinfo application in the `bookinfo` project by applying the bookinfo.yaml**
```
$ oc apply -n bookinfo -f https://raw.githubusercontent.com/tosin2013/openshift-demos/master/istio/templates/bookinfo.yaml
```

**Test Deployment**
```
$ oc get pods
```

```
$ oc exec jsonpath='{.items[0].metadata.name}') -c ratings -- curl productpage:9080/productpage | grep -o "<title>.*</title>"
<title>Simple Bookstore App</title>
```
**Adding destination rule for all mtls**
```
$ oc create -f https://raw.githubusercontent.com/tosin2013/openshift-demos/master/istio/templates/destination-rule-all-mtls.yaml
```

**Follow the cert creation steps found in link below**  
[Secure Gateways (File Mount) On OpenShift Isito](secure-gateways-on-openshift-isito.md)  

**Create the ingress gateway using port 443 by applying the bookinfo-gateway.yaml using Secure Gateways (File Mount)**
```
vi bookinfo-secure-gateway.yml

apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
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
   - "*.apps.ocp4.example.com"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
 name: bookinfo
spec:
 hosts:
 - "*.apps.ocp4.example.com"
 gateways:
 - bookinfo-gateway
 http:
 - match:
   - uri:
       exact: /productpage
   - uri:
       exact: /login
   - uri:
       exact: /logout
   - uri:
       prefix: /api/v1/products
   route:
   - destination:
       host: productpage
       port:
        number: 9080
```

**Create Secure Route**
```
$ oc create  route passthrough bookinfo --service=istio-ingressgateway  --insecure-policy=Redirect --port https  -n istio-system
```

**Set the value for the GATEWAY_URL variable**
```
$ export GATEWAY_URL=$(oc -n istio-system get route bookinfo -o jsonpath='{.spec.host}')
```

**Validate Deployment**
```
$ curl -o /dev/null -s -w "%{http_code}\n" https://$GATEWAY_URL/productpage -k
```

*Or navigate to  `https://$GATEWAYURL/productpage` in your browser.*
```
$ echo https://$GATEWAY_URL/productpage
```

**You can now open tools like kiali**

## Links:
[Deploying applications on Red Hat OpenShift Service Mesh](https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_day_two/prepare-to-deploy-applications-ossm.html)  
[Kiali tutorial](https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_day_two/ossm-tutorial-kiali.html)  
[Distributed tracing tutorial](https://docs.openshift.com/container-platform/4.3/service_mesh/service_mesh_day_two/ossm-tutorial-jaeger-tracing.html)  