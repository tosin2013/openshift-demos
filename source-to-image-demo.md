# Source-to-Image Builders


**Login to OpenShift**
```
# in standard OpenShift deployment
oc login -u your_username
# in minishift
oc login -u developer
```

**lets create the source to image project**
```
oc new-project source-to-image

#minishift use myproject
oc project myproject
```

**Download s2i cli**
[releases](https://github.com/openshift/source-to-image/releases)

**Via MAC**
```
curl -OL https://github.com/openshift/source-to-image/releases/download/v1.1.13/source-to-image-v1.1.13-b54d75d3-darwin-amd64.tar.gz
tar -zxvf source-to-image-v1.1.13-b54d75d3-darwin-amd64.tar.gz
chmod +x s2i
mv s2i /usr/local/bin/
```

**Via LINUX**
```
curl -OL https://github.com/openshift/source-to-image/releases/download/v1.1.13/source-to-image-v1.1.13-b54d75d3-linux-amd64.tar.gz
tar -zxvf source-to-image-v1.1.13-b54d75d3-linux-amd64.tar.gz
chmod +x s2i
mv s2i /usr/local/bin/
```
**Mananully build an s2i image on machine**
```
git clone https://github.com/tosin2013/simple-http-server.git
cd simple-http-server
cat Dockerfile
docker build -t simple-http-server .
s2i build \
https://github.com/BlackrockDigital/startbootstrap-landing-page\
simple-http-server \
static-web-site
docker images
docker run --rm -p 8080:8080 static-web-site
```

**Building an s2i images using OpenShift**
```
oc new-build --name simple-http-server --strategy=docker \
  --code https://github.com/tosin2013/simple-http-server

oc start-build simple-http-server
oc new-app simple-http-server~https://github.com/BlackrockDigital/startbootstrap-landing-page
```

**Import an s2i images using OpenShift**
```
oc import-image openshiftkatacoda/simple-http-server --confirm
oc new-app simple-http-server~https://github.com/BlackrockDigital/startbootstrap-landing-page
```


**delete demo**
```
oc delete all --selector app=startbootstrap-landing-page
```

**Links:**
[Deploying Applications from Images in OpenShift, Part One: Web Console](https://blog.openshift.com/deploying-applications-from-images-in-openshift-part-one-web-console/)
