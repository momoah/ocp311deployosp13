source ./openrc311.sh

openstack network create ocp-deploy

# Original instructions include a dns nameserver, which I'm leaving out because I have other settings in network-environment.yaml
# Added so Tenant VMs can be resolved in the tenant network. Ensure the network/subnet doesn't have a dns server set, and it will add it's own to VMs
#  NeutronDnsDomain: vm.osp.momolab
#  NeutronDhcpAgentDnsmasqDnsServers: [ "192.168.1.150" ]
#  NeutronPluginExtensions: [ "qos", "port_security", "dns" ]

openstack subnet create --network ocp-deploy \
  --subnet-range 192.168.100.0/24 \
  ocp-deploy-subnet

openstack router create ocp-deploy-router

openstack router set --external-gateway public ocp-deploy-router

openstack router add subnet ocp-deploy-router ocp-deploy-subnet


