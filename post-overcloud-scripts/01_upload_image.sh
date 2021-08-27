
# ~/rhel7.7_image.qcow2
source ~/overcloudrc

openstack image create --public \
--disk-format qcow2 --container-format bare \
--file ~/images/rhel-server-7.9-x86_64-kvm.qcow2 rhel7.9
