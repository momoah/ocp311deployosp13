source ./openrc311.sh

openstack floating ip create public
# The command below assumes there is only one floating ip present. If more than one are present or all assigned, this command will fail.
# If you have more than one floating IP just run the command manually.

openstack server add floating ip ocp-deploy $(openstack floating ip list -c 'Floating IP Address' -f value)
openstack server list
