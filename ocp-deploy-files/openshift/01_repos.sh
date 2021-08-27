# This assumes you have already run:
# 1- sudo subscription-manager register
# 2- sudo subscription-manager attach --pool=1234


sudo subscription-manager repos \
    --enable="rhel-7-server-rpms" \
    --enable="rhel-7-server-extras-rpms" \
    --enable="rhel-7-server-ose-3.11-rpms" \
    --enable="rhel-7-server-ansible-2.9-rpms" \
    --enable="rhel-7-server-openstack-13-rpms" \
    --enable="rhel-7-server-openstack-14-rpms" \
    --enable="rhel-server-rhscl-7-rpms" \
    --enable="rhel-7-server-openstack-13-tools-rpms"

sudo yum -y install openshift-ansible-3.11.501 python-openstackclient python2-heatclient python2-octaviaclient python2-shade python-dns git ansible-2.9 tmux

sudo subscription-manager repos --disable=rhel-7-server-openstack-13-tools-rpms 
 
sudo yum update ansible -y
sudo yum update python2-openstacksdk -y

# Still not sure about the need for these below.

#sudo subscription-manager repos --enable=rhel-server-rhscl-7-rpms
#sudo yum install python27-python-pip -y
#scl enable python27 bash
#which pip
#pip -V


#pip install --upgrade --user urllib3==1.22
#pip install --upgrade --user chardet==3.0.2
# pip install --install --user shade==1.27 
