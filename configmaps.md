# Using ConfigMaps
**Login to OpenShift**
```
oc login -u developer
```

**Clone Sample Application from git**
```
git clone https://github.com/jorgemoralespou/ose-app-promotion-configmap.git
cd ose-app-promotion-configmap/example1
```
**lets set the color we would like to use**
```
COLOR=red
echo "color=$COLOR" > ui.properties
```
**lets create the config map project**
```
oc new-project configmap-example

#minishift use myproject
oc project myproject
```

**Let’s create a ConfigMap, named config, with both a literal text, message=Hello world!, and the configuration file:**
```
PERSONAL_MESSAGE="YOUR MESSAGE"
oc create configmap config \
            --from-literal=message="${PERSONAL_MESSAGE}" \
            --from-file=ui.properties
```

**Check the contents of configmap/config**
```
oc get configmap/config -o json
```

**create the app deploymet and build the app**
```
oc create -f node-app-deployment.json
oc create -f node-app-build.json
```

**delete demo**
```
oc delete all --selector app=node-app
```
**Links**  
[Configuring your application](https://blog.openshift.com/configuring-your-application-part-1/)
