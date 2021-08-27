source ./openrc311.sh

openstack security group create ocp-deploy

openstack security group list

openstack security group rule create \
    --ingress \
    --protocol icmp \
    ocp-deploy
openstack security group rule create \
    --ingress \
    --protocol tcp \
    --dst-port 22 \
    ocp-deploy

openstack security group rule list ocp-deploy

