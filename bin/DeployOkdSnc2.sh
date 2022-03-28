#!/bin/bash

set -x

# This script will set up the infrastructure to deploy a single node OKD 4.X cluster
CPU=${SNC_CPU:-20}
MEMORY=${SNC_MEMORY:-61440}
DISK=${SNC_DISK:-200}
FCOS_VER=${FCOS_VER:-35.20220227.3.0}
FCOS_STREAM=${FCOS_STREAM:-stable}

for i in "$@"
do
case $i in
    -c=*|--cpu=*)
    CPU="${i#*=}"
    shift
    ;;
    -m=*|--memory=*)
    MEMORY="${i#*=}"
    shift
    ;;
    -d=*|--disk=*)
    DISK="${i#*=}"
    shift
    ;;
    *)
          # unknown option
    ;;
esac
done

# Create the OKD Node VM
MASTER_MAC="52:54:00:fb:85:a1"
#mkdir -p /VirtualMachines/okd4-snc-master
# virt-install --name okd4-snc-master --memory ${MEMORY} --vcpus ${CPU} --disk size=${DISK},path=/VirtualMachines/okd4-snc-master/rootvol,bus=sata --cdrom /tmp/rhcos-live.x86_64.iso --network bridge=virbr0 --mac=${MASTER_MAC} --graphics none --noautoconsole --os-variant centos7.0 --check disk_size=off
# virt-install --name okd4-snc-master --memory ${MEMORY} --vcpus ${CPU} --disk size=${DISK},path=/VirtualMachines/okd4-snc-master/rootvol,bus=sata --cdrom /tmp/systemrescue-9.01-amd64.iso --network bridge=virbr0 --mac=${MASTER_MAC} --graphics none --noautoconsole --os-variant centos7.0 --check disk_size=off


# virt-install \
# --name okd4-snc-master \
# --memory ${MEMORY} \
# --vcpus=${CPU} \
# --disk path=/VirtualMachines/okd4-snc-master,bus=virtio,size=${DISK} \
# -c /tmp/systemrescue-9.01-amd64.iso \
# --vnc \
# --noautoconsole \
# --os-type linux \
# --os-variant centos7.0 \
# --accelerate \
# --network=bridge:virbr0,model=virtio \
# --mac=${MASTER_MAC} \
# --hvm \
# --check disk_size=off


virt-install \
--name okd4-snc-master \
--memory ${MEMORY} \
--vcpus=${CPU} \
--disk path=/VirtualMachines/okd4-snc-master,bus=virtio,size=${DISK} \
-c /tmp/rhcos-live.x86_64.iso \
--vnc \
--noautoconsole \
--os-type linux \
--os-variant centos7.0 \
--accelerate \
--network=bridge:virbr0,model=virtio \
--mac=${MASTER_MAC} \
--hvm \
--check disk_size=off