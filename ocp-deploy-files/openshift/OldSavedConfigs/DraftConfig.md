$ cat inventories/clusters/dev2-dca1/group_vars/all/crio.yml

---

# enable cri-o section
openshift_use_crio: True
openshift_use_crio_only: True
openshift_crio_enable_docker_gc: False
osm_use_cockpit: False

openshift_openstack_master_group_name: node-config-master-crio
openshift_openstack_compute_group_name: node-config-compute-crio
openshift_openstack_infra_group_name: node-config-infra-crio

 
$ cat inventories/clusters/dev2-dca1/group_vars/all/kuryr.yml

## Kuryr configuration
openshift_use_kuryr: True
openshift_use_openshift_sdn: False
use_trunk_ports: True
os_sdn_network_plugin_name: cni
openshift_node_proxy_mode: userspace
kuryr_openstack_pool_driver: nested

# The value below needs to be set based on openshift_openstack_kuryr_pod_subnet_prefixlen based on tuning efforts.

openshift_kuryr_precreate_subports: false
kuryr_openstack_pool_batch: 3
kuryr_openstack_pool_max: 5
kuryr_openstack_pool_min: 1

kuryr_openstack_ca: "{{custom_certs_dir}}/CA_Bundle.txt"

openshift_openstack_kuryr_controller_image: "satellite.csda.gov.au:5000/dhs_standard_org-ocp311-openshift3_kuryr-controller:{{ openshift_image_tag }}"
openshift_openstack_kuryr_cni_image: "satellite.csda.gov.au:5000/dhs_standard_org-ocp311-openshift3_kuryr-cni:{{ openshift_image_tag }}"

kuryr_openstack_public_net_id: dae90afe-c0b5-4a30-954b-8a5f7df8424a

# Adding metrics server to allow autoscaling

kuryr_openstack_global_namespaces: default,openshift-monitoring

# To disable namespace isolation, comment out the next 2 lines
openshift_kuryr_subnet_driver: namespace
openshift_kuryr_sg_driver: namespace

openshift_master_open_ports:
- service: dns tcp
  port: 53/tcp
- service: dns udp
  port: 53/udp

openshift_node_open_ports:
- service: dns tcp
  port: 53/tcp
- service: dns udp
  port: 53/udp

 
# Custom Settings:

# openshift_openstack_kuryr_service_subnet_cidr divided into two ranges
# Range 1: service netowrk (openshift_portal_net)
# Range 2: Amphora IP pool (openshift_openstack_kuryr_service_pool_start/end)
# The settings below mean the following:
# - Portal net (service IPs) will have 192.168.128.0-192.168.159.254
# - Amphora IPs will have 192.168.160.1-19.168.191.254
# - Pods will have  192.168.0.1-192.168.127.254

#SERVICE
openshift_portal_net: 192.168.128.0/19
openshift_openstack_kuryr_service_subnet_cidr: 192.168.128.0/18
openshift_openstack_kuryr_service_pool_start: 192.168.160.1
openshift_openstack_kuryr_service_pool_end: 192.168.191.253

#POD
openshift_openstack_kuryr_pod_subnet_cidr: 192.168.0.0/17

# Pods per namespace determined by prefixlen (/24 = 256 pods per ns, /25 = 128 pods per ns, /26 = 64 pods per ns)
# See: https://gitlab.csda.gov.au/ICT-INFRA/openshift/platform-administration/-/issues/250#note_661344
# Updated to openshift_openstack_kuryr_pod_subnet_prefixlen in 3.11.219

openshift_openstack_kuryr_pod_subnet_prefixlen: 26

 

# Based on issue #317, remote_ip_prefix replaced remote_group_id, and the kuryr pod network is added here.

openshift_openstack_node_secgroup_rules:

  # NOTE(shadower): the 53 rules are needed for Kuryr
  - direction: ingress
    protocol: tcp
    port_range_min: 53
    port_range_max: 53

  - direction: ingress
    protocol: udp
    port_range_min: 53
    port_range_max: 53

  - direction: ingress
    protocol: tcp
    port_range_min: 10250
    port_range_max: 10250
    remote_ip_prefix: "{{ openshift_openstack_kuryr_pod_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 10250
    port_range_max: 10250
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

  - direction: ingress
    protocol: udp
    port_range_min: 4789
    port_range_max: 4789
    remote_ip_prefix: "{{ openshift_openstack_kuryr_pod_subnet_cidr }}"

  - direction: ingress
    protocol: udp
    port_range_min: 4789
    port_range_max: 4789
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 9100
    port_range_max: 9100
    remote_ip_prefix: "{{ openshift_openstack_kuryr_pod_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 9100
    port_range_max: 9100
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 8444
    port_range_max: 8444
    remote_ip_prefix: "{{ openshift_openstack_kuryr_pod_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 8444
    port_range_max: 8444
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

# End of Kuryr configuration

 

$ cat inventories/core/group_vars/OSEv3.yml

---

ansible_become: true

 

# Based on: https://access.redhat.com/support/cases/#/case/02336733
# We need to specifc the etcd_ca_host as master-0
etcd_ca_host: "master-0.{{ openshift_openstack_full_dns_domain }}"


openshift_deployment_type: openshift-enterprise
 
openshift_release: '3.11'

#the below var has moved to inventories/core/group_vars/all/vars.yml
#this is so its always available in any inventory

#openshift_minor_release: 3.11.232

openshift_image_tag: "v{{ openshift_minor_release }}"
openshift_pkg_version: "-{{ openshift_minor_release }}"

openshift_master_default_subdomain: apps.{{openshift_openstack_full_dns_domain}}
openshift_master_cluster_public_hostname: console.{{openshift_openstack_full_dns_domain}}

openshift_hosted_router_wait: True
openshift_hosted_registry_wait: True

openshift_cloudprovider_kind: openstack
openshift_cloudprovider_openstack_auth_url: "{{ lookup('env','OS_AUTH_URL') }}"
openshift_cloudprovider_openstack_username: "{{ lookup('env','OS_USERNAME') }}"
openshift_cloudprovider_openstack_domain_name: "{{ lookup('env','OS_USER_DOMAIN_NAME') }}"
openshift_cloudprovider_openstack_password: "{{ lookup('env','OS_PASSWORD') }}"
openshift_cloudprovider_openstack_tenant_name: "{{ lookup('env','OS_PROJECT_NAME') }}"
openshift_cloudprovider_openstack_region: "{{ lookup('env', 'OS_REGION_NAME') }}"
openshift_cloudprovider_openstack_blockstorage_version: v2

 

# Cinder volume for Openshift registry:

openshift_hosted_registry_storage_kind: openstack
openshift_hosted_registry_storage_access_modes: ['ReadWriteOnce']
openshift_hosted_registry_storage_openstack_filesystem: xfs
openshift_hosted_registry_storage_volume_size: 100Gi
openshift_hosted_registry_storage_volume_name: registry
openshift_hosted_registry_storage_volume_type: sas
openshift_hosted_registry_storage_annotations: ['volume.beta.kubernetes.io/storage-class: standard']

openshift_hostname_check: false

ansible_ssh_private_key_file: "/home/openshift/.ssh/id_rsa-openshift-{{openshift_environment}}-ocp-deploy"

# This customisation comes from the different formating docker images have in satellite.
# similar to: https://blog.openshift.com/using-satellite-6-server-disconnect-openshift-container-platform-install/

oreg_url: satellite.csda.gov.au:5000/dhs_standard_org-ocp311-openshift3_ose-${component}:${version}
openshift_disable_check: "docker_image_availability"
openshift_docker_insecure_registries: "satellite.csda.gov.au:5000,registry-gitlab.csda.gov.au"
openshift_docker_additional_registries: "satellite.csda.gov.au:5000,registry-gitlab.csda.gov.au"
openshift_docker_blocked_registries: "docker.io,registry.fedoraproject.org,quay.io,registry.centos.org,docker.io"
openshift_examples_modify_imagestreams: True
oreg_test_login: false
openshift_examples_registryurl: "{{ oreg_url }}"
registry_host: "{{ openshift_examples_registryurl.split('/')[0] }}"

osm_etcd_image: "satellite.csda.gov.au:5000/dhs_standard_org-ocp311-rhel7_etcd:{{ r_etcd_default_version }}"


### Authentication
 

openshift_master_identity_providers:

  - name: htpasswd_auth
    kind: HTPasswdPasswordIdentityProvider
    login: true
    challenge: true
 

# The ldap_server_fqdn and vault_ldap_bind_password will change depending on what environment is chosen.
# ldap_server_fqdn is from:   inventories/environments/<env>/group_vars/all/vars.yml
# vault_ldap_bind_password is from:   inventories/environments/<env>/group_vars/all/vault.yml
# LDAPS is to be implemented at a later stage, once the certificate is available.

  - name: "ISP Universal"
    kind: LDAPPasswordIdentityProvider
    login: true
    challenge: true
    url: "ldap://{{ ldap_server_fqdn }}:389/ou=users,ou=staff,o=DHS,C=AU?CN"
    bindDN: CN=SVC-OPENSHIFT,ou=users,ou=staff,o=DHS,C=AU
    bindPassword: "{{ vault_ldap_bind_password }}"
    insecure: true
    attributes:
      id: ['DN']
      name: ['CN']
      preferredUsername: ['CN']

# Password for both users is redhat 
openshift_master_htpasswd_users:

  admin: '$apr1$7sB5jHiw$9a0tdgSrsWPkTM9TpVZFk0'
  dev: '$apr1$7sB5jHiw$9a0tdgSrsWPkTM9TpVZFk0'

# -- Networking

#os_sdn_network_plugin_name: 'redhat/openshift-ovs-multitenant'
# Commenting the networking section out, since we are using Kuryr and CRI-O.
#osm_cluster_network_cidr: 192.168.0.0/17 # Pod network
#osm_host_subnet_length: 8                # /24 pod network per node
#openshift_portal_net: 192.168.128.0/18   # Services network (SkyDNS)
#openshift_docker_bip: 192.168.193.1      # Docker network
#openshift_docker_options: "--bip={{openshift_docker_bip}}/24 --fixed-cidr={{openshift_docker_bip}}/25 --log-driver=journald"

#Optional Metrics

# This is depricated moving into OCP 4+, so we are not installing it.
openshift_metrics_install_metrics: false

#Enable OpenShift Container Metrics Server for Horizontal Pod Autoscaling, as per:

openshift_metrics_server_install: true

# Instead, we are installing the cluster monitoring operator.
# This is setup at install time, but can be re-installed if a change is made with the command:
# ./bin/ansible-playbook /usr/share/ansible/openshift-ansible/playbooks/openshift-monitoring/config.yml

openshift_cluster_monitoring_operator_install: true
openshift_cluster_monitoring_operator_prometheus_storage_enabled: true
openshift_cluster_monitoring_operator_alertmanager_storage_enabled: true

# The storage class name below comes from the command `oc get storageclass`

openshift_cluster_monitoring_operator_prometheus_storage_class_name: "fast"
openshift_cluster_monitoring_operator_alertmanager_storage_class_name: "standard"
openshift_cluster_monitoring_operator_prometheus_storage_capacity: "100Gi"
openshift_cluster_monitoring_operator_alertmanager_storage_capacity: "2Gi"
openshift_cluster_monitoring_operator_node_selector: {"node-role.kubernetes.io/infra":"true"}

template_service_broker_install: false
openshift_enable_service_catalog: false
ansible_service_broker_install: false
 
openshift_enable_olm: false

#Optional Aggregated Logging

openshift_logging_install_logging: true
openshift_logging_es_pvc_dynamic: true
openshift_logging_es_pvc_size: 1000Gi
openshift_logging_es_pvc_storage_class_name: standard
openshift_logging_es_cluster_size: 3
openshift_logging_es_number_of_replicas: 1
openshift_logging_es_nodeselector: {"node-role.kubernetes.io/infra":"true"}
openshift_logging_kibana_nodeselector: {"node-role.kubernetes.io/infra":"true"}
openshift_logging_curator_nodeselector: {"node-role.kubernetes.io/infra":"true"}

openshift_logging_es_allow_external: true

 

# Adding event router

# See: https://docs.openshift.com/container-platform/3.11/install_config/aggregate_logging.html#aggregate-logging-ansible-variables

openshift_logging_install_eventrouter: true
openshift_logging_eventrouter_cpu_limit: 150m
openshift_logging_eventrouter_cpu_request: 150m
openshift_logging_eventrouter_nodeselector: {"node-role.kubernetes.io/infra":"true"}

ansible_user: openshift
openshift_openstack_disable_root: true
openshift_openstack_user: openshift


# -- Certificates


# https://docs.openshift.com/container-platform/3.11/install_config/redeploying_certificates.html#install-config-cert-expiry

openshift_master_bootstrap_auto_approve: true

custom_certs_dir: "{{project_root}}/files/certs"
dhs_ca_bundle: "{{custom_certs_dir}}/DHS_PROD_CA_Bundle.txt"

openshift_master_overwrite_named_certificates: true

openshift_master_named_certificates:
  - names: ["{{openshift_master_cluster_public_hostname}}"]
    certfile: "{{custom_certs_dir}}/{{openshift_master_cluster_public_hostname}}.cer"
    keyfile: "{{custom_certs_dir}}/{{openshift_master_cluster_public_hostname}}_key"
    cafile: "{{dhs_ca_bundle}}"

openshift_hosted_router_certificate:
  certfile: "{{custom_certs_dir}}/wc.{{openshift_master_default_subdomain}}.cer"
  keyfile: "{{custom_certs_dir}}/wc.{{openshift_master_default_subdomain}}_key"
  cafile: "{{dhs_ca_bundle}}"


$ cat inventories/core/group_vars/all/vars.yml

---

openshift_minor_release: 3.11.272

ntp_servers: ["192.168.1.150"]
openshift_install_examples: false


openshift_environment: "{{environment_id}}-{{datacentre_id}}"
openshift_openstack_clusterid: "openshift-{{openshift_environment}}"
openshift_openstack_public_dns_domain: "csda.gov.au"
openshift_openstack_full_dns_domain: "{{openshift_openstack_clusterid}}.{{openshift_openstack_public_dns_domain}}"

 

## openstack vars to generate cloud config source envvars

openstack_auth_url: https://openstack-{{datacentre_id}}.csda.gov.au:13000/v3
openstack_project: openshift-{{openshift_environment}}
openstack_domain: dhs
openstack_user_domain: "{{openstack_domain}}"
openstack_project_domain: "{{openstack_domain}}"
openstack_username: SVC-OPENSHIFT-{{openshift_environment | upper}}
openstack_password: "{{ lookup('vars', 'vault_openstack_password_' + datacentre_id) }}"

openshift_openstack_keypair_name: "openshift-{{openshift_environment}}-ocp-deploy"
openshift_openstack_default_image_name: "rhel-7-x86_64-openshift"

 
# networking

openshift_openstack_node_subnet_name: openshift-{{openshift_environment}}-subnet
openshift_openstack_router_name: openshift-{{openshift_environment}}-router
openshift_openstack_master_floating_ip: false
openshift_openstack_infra_floating_ip: false
openshift_openstack_compute_floating_ip: false

# assuming the following:

# 192.168.0.0/17 is used for pod network
# 192.168.128.0/18 is used for service network

openshift_openstack_subnet_cidr: "192.168.192.0/24"
openshift_openstack_pool_start: "192.168.192.3"
openshift_openstack_pool_end: "192.168.192.254"

# node count

openshift_openstack_num_masters: 3
openshift_openstack_num_infra: 3
openshift_openstack_num_cns: 0
openshift_openstack_num_nodes: 4
openshift_openstack_num_etcd: 0

# node flavors

openshift_openstack_master_flavor: "ocp.master"
openshift_openstack_infra_flavor: "ocp.infra"
openshift_openstack_node_flavor: "ocp.node"
openshift_openstack_bastion_flavor: "dhs.prod"
openshift_openstack_default_flavor: "ocp.node"

# misc

openshift_openstack_use_lbaas_load_balancer: true

# create separate cinder volumes for docker & etcd

openshift_openstack_docker_volume_size: "200"
openshift_openstack_docker_volume_type: "nvme"
openshift_openstack_etcd_volume_size: "50"

# schedule master & infra nodes on different openstack hosts for HA
# For production, please ensure '[anti-affinity]' is set to ensure
# each master/infra is on a different host

openshift_openstack_master_server_group_policies: '[soft-anti-affinity]'
openshift_openstack_infra_server_group_policies: '[soft-anti-affinity]'

# Additional ports required by Prometheus to monitor extras:

# roles/openshift_openstack/defaults/main.yml
# Adding it here with my extra ports will automatically add the extra ports (9100,8444) in my security groups

# As per issue #317, all remote_group_id are replaced with remote_ip_prefix
# There is an openshift_openstack_node_secgroup_rules in each cluster specific kuryr.conf
# which will over write this one

openshift_openstack_node_secgroup_rules:

  # NOTE(shadower): the 53 rules are needed for Kuryr
  - direction: ingress
    protocol: tcp
    port_range_min: 53
    port_range_max: 53

  - direction: ingress
    protocol: udp
    port_range_min: 53
    port_range_max: 53

  - direction: ingress
    protocol: tcp
    port_range_min: 10250
    port_range_max: 10250
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

  - direction: ingress
    protocol: udp
    port_range_min: 4789
    port_range_max: 4789
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 9100
    port_range_max: 9100
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 8444
    port_range_max: 8444
    remote_ip_prefix: "{{ openshift_openstack_subnet_cidr }}"
 

openshift_openstack_etcd_secgroup_rules:

  - direction: ingress
    protocol: tcp
    port_range_min: 2379
    port_range_max: 2379
    remote_ip_prefix: "{{ openshift_openstack_master_ingress_cidr }}"

  - direction: ingress
    protocol: tcp
    port_range_min: 2380
    port_range_max: 2380
    remote_ip_prefix: "{{ openshift_openstack_master_ingress_cidr }}"

 
