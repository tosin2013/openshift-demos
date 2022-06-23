#!/bin/bash 
cd ~/applications/managed/
rm -rf amq-broker 
git add -A
git commit -m "Cleanup"
git push
cd ~


cd ~/rhacm-configuration/rhacm-root/subscriptions/
rm -rf amq-broker 
git add -A
git commit -m "Cleanup"
git push
cd ~