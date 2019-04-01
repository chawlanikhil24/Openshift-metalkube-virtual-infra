#!/usr/bin/sh


VM_COUNT=${1}
VM_COUNT="${VM_COUNT:-3}"
VM_COUNT=$(( VM_COUNT - 1 ))


export OS_TOKEN=fake-token
export OS_URL=http://localhost:6385/


for count in $(seq 0 $VM_COUNT );do
	echo "Trying to Delete node: "$count
	openstack baremetal node delete openshift_master_${count}
	sleep 1
done

cd dev-scripts
make clean

for count in $(seq 0 $VM_COUNT);do sudo vbmc stop openshift_master_${count};done
for count in $(seq 0 $VM_COUNT);do sudo vbmc delete openshift_master_${count};done
