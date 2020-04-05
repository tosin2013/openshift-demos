# Deploying Istio bookinfo app on OpenShift 4.2

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

**Add the bookinfo project to the ServiceMeshMemberRoll**
```
$ oc -n istio-system patch --type='json' smmr default -p '[{"op": "add", "path": "/spec/members", "value":["'"bookinfo"'"]}]'
```

**Deploy the Bookinfo application in the `bookinfo` project by applying the bookinfo.yaml**
```
$ oc apply -n bookinfo -f https://raw.githubusercontent.com/Maistra/bookinfo/maistra-1.0/bookinfo.yaml
```

**Create the ingress gateway using port 80 by applying the bookinfo-gateway.yaml**
```
apiVersion: networking.istio.io/v1alpha3
kind: Gateway
metadata:
  name: bookinfo-gateway
spec:
  selector:
    istio: ingressgateway # use istio default controller
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
---
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: bookinfo
spec:
  hosts:
  - "*"
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


**Set the value for the GATEWAY_URL variable**
```
$ export GATEWAY_URL=$(oc -n istio-system get route istio-ingressgateway -o jsonpath='{.spec.host}')
```

**Add default destination rules**  
*when mutual TLS is disabled*
```
$ oc apply -n bookinfo -f https://raw.githubusercontent.com/istio/istio/release-1.1/samples/bookinfo/networking/destination-rule-all.yaml
```

**Validate Deployment**
```
curl -o /dev/null -s -w "%{http_code}\n" http://$GATEWAY_URL/productpage
```

*Or navigate to  `http://$GATEWAYURL/productpage` in your browser.*
```
echo http://$GATEWAY_URL/productpage
```

**You can now open tools like kiali**

## Links:
* [Deploying applications on Red Hat OpenShift Service Mesh](https://docs.openshift.com/container-platform/4.2/service_mesh/service_mesh_day_two/prepare-to-deploy-applications-ossm.html)  
* [Kiali tutorial](https://docs.openshift.com/container-platform/4.2/service_mesh/service_mesh_day_two/ossm-tutorial-kiali.html)  
* [Distributed tracing tutorial](https://docs.openshift.com/container-platform/4.2/service_mesh/service_mesh_day_two/ossm-tutorial-jaeger-tracing.html)  
