# Steps required to get OpenShift 3.11 with Kuryr installed OpenStack 13z16

## When deploying the overcloud

Check contents of `director-deploy-extras-for-ocp311` to see what modifications are important to run your OpenShift 3.11 cluster

## Once overcloud is deployed

Check the contents of `post-overcloud-scripts` once you have an overcloud with enough resources, you can pretty much run scripts in sequence 01,02,03, ...

## Once your ocp-deploy host has been created

Once you have an ocp-deploy host, ensure you allow password authentication for cloud-user and root, and copy the files in: `ocp-deploy-files`, and run through the steps.

