source ~/overcloudrc

openstack network create public \
  --external \
  --provider-network-type flat \
  --provider-physical-network datacentre

openstack subnet create public-subnet \
  --network public \
  --dhcp \
  --allocation-pool start=192.168.1.242,end=192.168.1.254 \
  --gateway 192.168.1.1 \
  --subnet-range 192.168.1.0/24

openstack network list
openstack subnet list

