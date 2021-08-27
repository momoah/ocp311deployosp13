#!/usr/bin/env bash


# Clear any old environment that may conflict.
for key in $( set | awk '{FS="="}  /^OS_/ {print $1}' ); do unset $key ; done
export OS_PROJECT_DOMAIN_NAME=Default
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_NAME=ocp311
export OS_USERNAME=ocp311
export OS_PASSWORD=redhat
#export OS_AUTH_URL=http://192.168.1.236:5000//v3
export OS_CLOUDNAME=overcloud
export OS_IDENTITY_API_VERSION=3

# Add OS_CLOUDNAME to PS1
if [ -z "${CLOUDPROMPT_ENABLED:-}" ]; then
	export PS1=${PS1:-""}
	export PS1=\${OS_CLOUDNAME:+"(\$OS_CLOUDNAME)"}\ $PS1
	export CLOUDPROMPT_ENABLED=1
fi
export OS_AUTH_URL=http://192.168.1.238:5000//v3
