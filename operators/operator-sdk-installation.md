# Operator-SDK Installation
## Install Go
**MacOS**  
```
brew install go  
export GOPATH=$HOME/go  
export PATH=$PATH:/usr/local/bin:$GOPATH/bin  
```
**Linux**  
```
wget https://dl.google.com/go/go1.10.2.linux-amd64.tar.gz  
sudo tar -xvf go1.10.2.linux-amd64.tar.gz -C /usr/local/  
mkdir -p $HOME/go/src  
export GOPATH=$HOME/go  
export PATH=$PATH:/usr/local/go/bin:$GOPATH/bin  
```

**Windows**  
```
choco install golang  

Create folder at C:\go-work.  
Right click on “Start” and click on “Control Panel”. Select “System and Security”, then click on “System”.  
From the menu on the left, select the “Advanced systems settings”.  
Click the “Environment Variables” button at the bottom.  
Click “New” from the “User variables” section.  
Type GOPATH into the “Variable name” field.  
Type C:\go-work into the “Variable value” field.   
Click OK.  
```

## Install Dep
**MacOS**
```
brew install dep
```

**Linux**
```
curl https://raw.githubusercontent.com/golang/dep/master/install.sh | sh
```

**Windows**
```
choco install dep
```

## Install the Operator SDK
**Clone the Operator SDK (v0.3.0)**
```
mkdir -p $GOPATH/src/github.com/operator-framework
cd $GOPATH/src/github.com/operator-framework
git clone https://github.com/operator-framework/operator-sdk
cd operator-sdk
git checkout tags/v0.3.0 
```

**Install the Operator SDK’s dependencies.**
```
dep ensure -v
```

**Install the Operator SDK.**
```
go install -v github.com/operator-framework/operator-sdk/commands/operator-sdk
```

**Verify the Operator SDK was successfully installed. Verify you are on operator-sdk version v0.3.0**
```
operator-sdk --version
```

## Links
* [operator-sdk github](https://github.com/operator-framework/operator-sdk)
