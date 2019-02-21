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
oc new-project source-to-image-webhooks

#minishift use myproject
oc project myproject
```

**create a separate SSH key pair for use by OpenShift**
```
ssh-keygen -f ~/.ssh/github-blog-sshauth
```

**add ssh key to github**
```
https://help.github.com/articles/adding-a-new-ssh-key-to-your-github-account/
cat  ~/.ssh/github-blog-sshauth.pub
```
**Fork Code from blog-django-py**
* https://github.com/tosin2013/blog-django-py

**Create a secret in OpenShiftt**
```
oc secret new-basicauth user-at-github --username=tosinakinosho --prompt
```

**Grant the builder service account access to the secret**
```
oc secrets link builder user-at-github
```

**add an annotation to the secret to identify the source code repository**
```
oc annotate secret/github-blog-sshauth 'build.openshift.io/source-secret-match-uri-1=ssh://git@github.com:tosin2013/blog-django-py.git'
oc annotate secret/user-at-github \
    'build.openshift.io/source-secret-match-uri-1=https://github.com/tosin2013/blog-django-py.git'
```
**create the application using the SSH URI**
```
oc new-app --name blog --image-stream python \
  --code https://github.com/tosin2013/blog-django-py.git

oc set build-secret --pull bc/blog repo-at-github
oc new-app python~git@git@github.com:tosin2013/blog-django-py.git --name mysite
oc expose svc/blog
```

**determine the URL for the webhook callback**
```
$ oc describe bc/blog
Name:		blog
Namespace:	source-to-image-webhooks
Created:	About a minute ago
Labels:		app=blog
Annotations:	openshift.io/generated-by=OpenShiftNewApp
Latest Version:	1

Strategy:	Source
URL:		https://github.com/tosin2013/blog-django-py.git
Source Secret:	user-at-github
From Image:	ImageStreamTag openshift/python:3.6
Output to:	ImageStreamTag blog:latest

Build Run Policy:	Serial
Triggered by:		Config, ImageChange
Webhook GitHub:
  URL:	https://master.ocp.tosinakinosho.com:8443/apis/build.openshift.io/v1/namespaces/source-to-image-webhooks/buildconfigs/blog/webhooks/<secret>/github
Webhook Generic:
  URL:		https://master.ocp.tosinakinosho.com:8443/apis/build.openshift.io/v1/namespaces/source-to-image-webhooks/buildconfigs/blog/webhooks/<secret>/generic
  AllowEnv:	false
Builds History Limit:
  Successful:	5
  Failed:		5

Build	Status		Duration		Creation Time
blog-1 	running 	running for 1m0s 	2019-02-15 16:47:18 -0500 EST

Events:	<none>
```

**Webhook Generic Example**
```
$ curl -H "Content-Type: application/yaml" --data-binary @payload_file.yaml -X POST -k  https://master.ocp.tosinakinosho.com:8443/apis/build.openshift.io/v1/namespaces/source-to-image-webhooks/buildconfigs/blog/webhooks/mysecert/generic

cat payload_file.yaml
git:
  uri: "https://github.com/tosin2013/blog-django-py.git"
  ref: "master""
  commit: "push from openshift"
  author:
    name: "Tosin Akinosho"
    email: "takinosh@redhat.com"
  committer:
    name: "Tosin Akinosho"
    email: "takinosh@redhat.com"
  message: "push from openshift"
env:
  - name: "ENV"
    value: "PROD"
```
**Webhook GitHub Example**
$ curl -vvv -H "X-GitHub-Event: push" -H "Content-Type: application/json" -k -X POST --data-binary @payload.json https://master.ocp.tosinakinosho.com:8443/apis/build.openshift.io/v1/namespaces/source-to-image-webhooks/buildconfigs/blog/webhooks/mysecert/github


Links:
https://blog.openshift.com/private-git-repositories-part-1-best-practices/
