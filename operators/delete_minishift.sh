#!/bin/bash

echo "Delete the Minishift VM"
MINISHIFT_STATUS=$(minishift status)
if [[ $MINISHIFT_STATUS != "Does Not Exist" ]]; then
  minishift stop
fi
minishift delete || exit $?
rm -rf ~/.minishift
rm -rf ~/.kube
