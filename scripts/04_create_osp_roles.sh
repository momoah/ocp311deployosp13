source ~/overcloudrc
openstack project create ocp311
openstack user create --password redhat ocp311
openstack role add --user ocp311 --project ocp311 _member_
openstack quota set --networks 150 --subnets 150 --secgroups 300 --secgroup-rules 500 --ports 500 ocp311
openstack quota set --ram -1 --cores -1   ocp311
openstack project show ocp311
echo "ensure you add the PROJECT_ID to the octavia.conf on the controllers and restart (and as a controller extraconfig)"
