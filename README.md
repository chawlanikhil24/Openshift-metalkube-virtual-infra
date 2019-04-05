# Openshift-metalkube-virtual-infra
This repository has the scripts that automates the deployment of virtual machines that simulates bare-metal environment for Ironic.


# Pre-requisites

- CentOS 7.5 or greater (installed from 7.4 or newer)
- file system that supports d_type (see Troubleshooting section for more information)
- ideally on a bare metal host
- run as a user with passwordless sudo access

# Instructions

```shell
$ git clone https://github.com/chawlanikhil24/Openshift-metalkube-virtual-infra.git
$ cd Openshift-metalkube-virtual-infra
$ ./VM_automation.sh <specify the number of nodes to be Provisioned from IRONIC> --> Default count : 3```

Give it sometime, and at the end run the following command to check Ironic Provisioned Virtual Bare-metals:

```shell
$ openstack baremetal node list
```

Also, to check the Virtual Machines that are simulating the bare-metals, run:
```shell
$ sudo virsh -r list --all
```

To Delete the whole virtual setup and environment, run:
```
$ ./Cleaner.sh <specify the number of nodes Provisioned already> --> Default count: 3
```
---
# Note
###### If you are reprovisioning the setup, after runnning the "Cleaner.sh" script, then ,to save time, comment out "./01_install_requirements.sh" in "VM_automation.sh"
