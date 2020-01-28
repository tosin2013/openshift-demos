# Knative CLI Demo On OpenShift 4.2

## Requirements:
* install the kn cli

### Install kn cli on linux
```
wget https://mirror.openshift.com/pub/openshift-v4/clients/serverless/latest/kn-linux-amd64-0.10.0.tar.gz
tar -zxvf kn-linux-amd64-0.10.0.tar.gz
chmod +x kn
sudo mv kn /usr/local/bin/
kn version
```

#### For other operating systems please refer to the link below.
[Using Knative Client](https://docs.openshift.com/container-platform/4.2/serverless/knative-client.html)

**Login to OpenShift**
```
oc login --token=CHANGEME --server=https://api.example.com:6443
```

**Create new project**
```
oc new-project serverless-demo
```

**Verify namespace**
```
kn service list --namespace serverless-demo
```
**Create deployment**
```
kn service create echo --image tcij1013/echo:latest
```
**Reterive URL**
```
TESTURL=$(kn service list | grep echo | awk '{print $2}')
```

**Test URL or open in web browser**
```
echo $TESTURL
curl -s $TESTURL
```

**Configure concurrency limits on deployment**
```
kn service update echo --concurrency-limit=1
```

**Send traffic to deployment**
```
while true; do sleep 1; curl $TESTURL; echo -e '\n\n\n\n'$(date) hit CTRL-c to stop;done
```

**Change concurrency limit back to zero**
```
kn service update echo --concurrency-limit=0
```
**Set a deployment revision**
```
kn service update echo --revision-name echo-v1
curl -s  $TESTURL
```
**Pass new message to v2 deployment**
```
kn service update echo --revision-name echo-v2 --env MSG="OCP KNATIVE DEMO"
curl -s $TESTURL
```
**Add weight to traffic to spread it between v1 and v2**
```
kn service update echo --traffic echo-v1=50,echo-v2=50
while true; do sleep 1; curl $TESTURL; echo -e '\n\n\n\n'$(date) hit CTRL-c to stop;done
```

**Setup a deployment with a v3 revision see that traffic does not gt sent to this deployment**
```
kn service update echo --revision-name echo-v3 --env MSG="Having fun?"
while true; do sleep 1; curl $TESTURL; echo -e '\n\n\n\n'$(date) hit CTRL-c to stop;done
```

**Delete deployment**
```
kn service delete echo
```

Links:
[Knative Tutorial](https://redhat-developer-demos.github.io/knative-tutorial/knative-tutorial/0.7.x/index.html)
[Using Knative Client](https://docs.openshift.com/container-platform/4.2/serverless/knative-client.html)
