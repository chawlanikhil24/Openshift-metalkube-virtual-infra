#!/usr/bin/sh

VM_COUNT=${1}
VM_COUNT="${VM_COUNT:-3}"

echo "$VM_COUNT"

sudo yum install git python34-virtualenv  -y
virtualenv-3 venv

source venv/bin/activate
pip3 install jinja2
python3 script.py ${VM_COUNT}
deactivate #deactivate the virtual Environment

git clone https://github.com/openshift-metalkube/dev-scripts
rm -rf dev-scripts/tripleo-quickstart-config/metalkube-nodes.yml
mv out.yaml dev-scripts/tripleo-quickstart-config/metalkube-nodes.yml
cp -pr config_example.sh dev-scripts/config_${USER}.sh
cd dev-scripts


##Uncomment this if this is a fresh install
#./01_install_requirements.sh

./02_configure_host.sh

# Verify vms are present
sudo virsh list --all

#Setup Ironic
./04_setup_ironic.sh
sudo podman ps
export OS_TOKEN=fake-token
export OS_URL=http://localhost:6385/

#Ensure No baremetal is running
openstack baremetal node list
VM_COUNT=$(( VM_COUNT - 1 ))

for count in $(seq 0 $VM_COUNT );do
	openstack baremetal node create \
	  --name openshift_master_${count} \
	  --driver ipmi \
	  --driver-info ipmi_username=admin \
	  --driver-info ipmi_password=password \
	  --driver-info ipmi_address=192.168.111.1 \
	  --driver-info ipmi_port=$(( 6230 + count ))
done

echo "Wait for 60 seconds"
for i in $(seq 0 60);do
    echo "Waiting for nodes to come UP ."${i}" Seconds done..."
    sleep 1
done

for count in $(seq 0 $VM_COUNT );do
	echo "Trying to manage node: "$count
	openstack baremetal node manage openshift_master_${count}
	sleep 1
done


openstack baremetal node list 

