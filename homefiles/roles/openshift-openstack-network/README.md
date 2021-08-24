OpenShift OpenStack Network
===========================

Builds an OpenStack network stack for an OpenShift cluster with a bastion host.

Requirements
------------

- openshift-ansible
- python2-openstackclient
- python2-heatclient
- python2-shade

Role Variables
--------------

|Variable  |Default|Description      |
|----------|-------|-----------------|
|`openshift_openstack_network_action`|provision|Should be set to "provision" to create or update the stack, or "teardown" to delete the stack.|
|`openshift_openstack_network_stack_template_path`|{{role_path}}/files/stack.yml|Path to the HEAT template to use. Shouldn't need to be changed but allows the HEAT template to be overriden.|
|`openshift_openstack_network_stack_name`|openshift-network|Name of the OpneStack HEAT stack to be managed.|
|`openshift_openstack_bastion_hostname`|bastion|Short hostname to use for the bastion host. Will be used for the bastion hostname and instance name.|
|`openshift_openstack_bastion_flavor`|{{openshift_openstack_default_flavor}}|Name of the flavor to use for the bastion host.|
|`openshift_openstack_bastion_image`|{{openshift_openstack_default_image_name}}|Name of the image to use for the bastion host.|
|`openshift_openstack_bastion_ingress_cidr`|0.0.0.0/0|CIDR to allow ingress from to the bastion host.|
|`openshift_openstack_bastion_secgroup_rules`| Ingress for SSH & all ICMP from `openshift_openstack_bastion_ingress_cidr`|Security groups to apply to the bastion host.|


### Variables from openshift-ansible

These variables are used elsewhere in openshift-ansible, and will also be used by
this role for certain configuration. Default values should match those used by
openshift-ansible exactly.

|Variable  |openshift-ansible Description|Role Notes       |
|----------|-----------------------------|-----------------|
|`openshift_openstack_external_network_name`*|OpenStack public network name|                 |
|`openshift_openstack_router_name`*|Name of existing OpenShift router to use for deployment.|Name of the router that will be managed by this role.|
|`openshift_openstack_node_subnet_name`*|Name of existing OpenShift subnet to use for deployment.|Name of the subnet that will be managed by this role.|
|`openshift_openstack_full_dns_domain`|The DNS domain to use for the cluster.|Full domain name of the cluster.|
|`openshift_openstack_fqdn_nodes`|Whether to include the fqdn in OpenStack server names.|                 |
|`openshift_openstack_keypair_name`|Keypair name used to log into OCP instances|                 |
|`openshift_openstack_subnet_cidr`|CIDR for the node subnet created for deployment.|Will be used by the subnet created by this role instead of openshift-ansible.|
|`openshift_openstack_pool_start`|Start of the DHCP pool for the node subnet.|Will be used by the subnet created by this role instead of openshift-ansible.|
|`openshift_openstack_pool_end`|End of the DHCP pool for the node subnet.|Will be used by the subnet created by this role instead of openshift-ansible.|

Example Playbook
----------------

```yaml
---
- hosts: localhost
  roles:
    - openshift-openstack-network
  vars:
    openshift_openstack_network_action: provision
```

Authors
------------------

- Tom Stockwell (@THS081) &lt;tstockwell@redhat.com&gt;
