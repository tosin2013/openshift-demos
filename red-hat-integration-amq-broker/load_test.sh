#!/bin/bash 
set -xe 
URL="amq-broker-instance-wconsj-0-svc-rte-demo-amq-dc.apps.cluster-ljw9p.ljw9p.sandbox1520.opentlc.com"

x=1
while [ $x -le 100 ]
do
    arr[0]="ON"
    arr[1]="OFF"
    rand=$[$RANDOM % ${#arr[@]}]
    echo $(date)
    echo ${arr[$rand]}

    curl --location --request POST \
    --header 'Authorization: Basic YWRtaW46YWRtaW4=' \
    --header 'Content-Type: application/json' \
    --data-raw '{"type":"exec","mbean":"org.apache.activemq.artemis:broker=\"amq-broker\",component=addresses,address=\"sampleaddress\",subcomponent=queues,routing-type=\"multicast\",queue=\"sampleaddress\"","operation":"sendMessage(java.util.Map, int, java.lang.String, boolean, java.lang.String, java.lang.String, boolean)","arguments":[{},3,"'${arr[$rand]}'",true,null,null,false]}' \
    "http://${URL}/console/jolokia/?maxDepth=7&maxCollectionSize=50000&ignoreErrors=true&canonicalNaming=false" 

    sleep 2
done