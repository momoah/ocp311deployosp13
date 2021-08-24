sudo subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.11-rpms" \
    --enable="rhel-7-server-ansible-2.5-rpms" \
    --enable="rhel-7-server-openstack-13-rpms" \
    --enable="rhel-7-server-openstack-13-tools-rpms"

# Comment the lines below if you need to use Ansible-2.9

sudo subscription-manager repos --disable=rhel-7-server-openstack-13-tools-rpms --disable=rhel-7-server-ansible-2.5-rpms
sudo subscription-manager repos --enable=rhel-7-server-openstack-14-tools-rpms --enable=rhel-7-server-ansible-2.9-rpms
 
sudo yum update ansible -y
sudo yum update python2-openstacksdk -y

sudo subscription-manager repos --enable=rhel-server-rhscl-7-rpms
sudo yum install python27-python-pip -y
scl enable python27 bash
which pip
pip -V


pip install --upgrade --user urllib3==1.22
pip install --upgrade --user chardet==3.0.2

