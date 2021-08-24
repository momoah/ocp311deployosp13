source ./openrc311.sh

domain="Default"
netid1=$(openstack network show ocp-deploy -f value -c id)

openstack server create \
    --nic net-id=$netid1 \
    --flavor m1.node \
    --image rhel7.9 \
    --key-name ocp-deploy \
    --security-group ocp-deploy \
   ocp-deploy

