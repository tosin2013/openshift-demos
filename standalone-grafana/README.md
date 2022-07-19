# Deploy StandAlone Grafana in OpenShift

Create an project for the Grafana instance
```
oc new-project quarkuscoffeeshop-grafana
```

Search for the `Grafana Oeprator`
![](https://i.imgur.com/EvVBdk4.png)

Install the `alpha` release
![](https://i.imgur.com/6hJBLYz.png)

![](https://i.imgur.com/VxIZxaN.png)

Create Secert For Grafana dashboard
*This will be used for performance co-pilot*
```
kind: Secret
apiVersion: v1
metadata:
  name: grafana-env
  namespace: quarkuscoffeeshop-grafana
stringData:
  GF_INSTALL_PLUGINS: https://github.com/performancecopilot/grafana-pcp/releases/download/v5.0.0/performancecopilot-pcp-app-5.0.0.zip;performancecopilot-pcp-app
```


Create Grafana deployment
```
apiVersion: integreatly.org/v1alpha1
kind: Grafana
metadata:
  name: quarkuscoffeeshop-grafana
  namespace: quarkuscoffeeshop-grafana
spec:
  deployment:
    envFrom:
      - secretRef:
          name: grafana-env
    skipCreateAdminAccount: false
  config:
    auth:
      disable_signout_menu: true
    auth.anonymous:
      enabled: true
    log:
      level: warn
      mode: console
    security:
      admin_password: secret
      admin_user: root
  ingress:
    enabled: false
  dashboardLabelSelector:
    - matchExpressions:
        - key: app
          operator: In
          values:
            - grafana
```

Expose Grafana Route


The default username and password is found in the 
`grafana-admin-credentials` secret.
