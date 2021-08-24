source ./openrc311.sh

# ssh-keygen -t rsa # save as ocp-deploy     
# openssl rsa -in ocp-deploy.pem -pubout > ocp-deploy.pub
# openstack keypair create --private-key ../ocp-deploy.pem ocp-deploy

openstack keypair create --public-key ./ocp-deploy.pub  ocp-deploy 

openstack keypair list
