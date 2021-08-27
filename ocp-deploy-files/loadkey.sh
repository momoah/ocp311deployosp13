#!/bin/bash

echo "Loading keys"

eval `ssh-agent`

ssh-add openshift/ocp-deploy.pem 

