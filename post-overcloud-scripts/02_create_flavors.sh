source ~/overcloudrc

openstack flavor create m1.master \
    --id auto \
    --ram 16384 \
    --disk 45 \
    --vcpus 4
openstack flavor create m1.node \
    --id auto \
    --ram 8192 \
    --disk 20 \
    --vcpus 1
