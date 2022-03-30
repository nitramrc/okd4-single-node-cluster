# okd4-single-node-cluster
Building an OKD4 SIngle Node Cluster with minimal resources

__Note: This project is being deprecated.__   

I'm moving this over to my Blog: [https://upstreamwithoutapaddle.com](https://upstreamwithoutapaddle.com)

The new post is here: [https://upstreamwithoutapaddle.com/blog%20post/2022/01/16/Let-It-Sno.html](https://upstreamwithoutapaddle.com/blog%20post/2022/01/16/Let-It-Sno.html)


__This project will no longer be maintained.  I will move it to an archive soon.__

This tutorial will guide you through deploying an OKD 4.7 cluster that is as minimal as possible.  It will consist of one node which is both master and worker.

You will need a CentOS Streams linux host with 2 cores and at least 32GB of RAM.

I am using a [NUC8i3BEK](https://ark.intel.com/content/www/us/en/ark/products/126149/intel-nuc-kit-nuc8i3bek.html) with 32GB of RAM for my host. This little box with 32GB of RAM is perfect for this purpose, and also very portable for throwing in a bag to take my dev environment with me.  Also check out the newer [NUC10i3FNK](https://ark.intel.com/content/www/us/en/ark/products/195503/intel-nuc-10-performance-kit-nuc10i3fnk.html).  It will support 64GB of RAM!

Follow the guide here: [OKD 4.7 Single Node Cluster](https://cgruver.github.io/okd4-single-node-cluster/)

Much of the material for this minimal cluster is borrowed from my other OKD 4.4 tutorial.  If you are interested in building a full OKD 4.4 cluster, then check it out here: [OKD 4.X Lab](https://cgruver.github.io/okd4-upi-lab-setup/).

__If you want to connect with a team of OpenShift enthusiasts, join us in the OKD Working Group:__

https://github.com/openshift/okd

https://github.com/openshift/community

# AWS baremetal
systemctl disable cloud-config.service cloud-final.service cloud-init-local.service cloud-init.service cloud-config.target cloud-init.target
systemctl stop cloud-config.service cloud-final.service cloud-init-local.service cloud-init.service cloud-config.target cloud-init.target

# patch
oc patch ClusterVersion version --type merge --patch '{"spec":{"upstream":"https://amd64.origin.releases.ci.openshift.org/graph"}}'

# force destroy debug

```
cd ${OKD4_SNC_PATH}
virsh destroy okd4-snc-bootstrap
virsh destroy okd4-snc-master
virsh undefine okd4-snc-bootstrap
virsh undefine okd4-snc-master
rm -rf okd4-install-dir/ syslinux-6.03* work-dir/ /VirtualMachines/okd4-snc-*

```

# libvirt
```
virsh net-update default add-last ip-dhcp-host '<host mac="52:54:00:fb:85:a1" ip="192.168.122.150"/>' --live --config --parent-index 0
```

# testing
```
OCP_VERSION=$OKD_RELEASE
cd ${OKD4_SNC_PATH}
yes | cp -f install-config-snc.yaml install-config.yaml
ISO_URL=$(openshift-install coreos print-stream-json | grep location | grep x86_64 | grep iso | cut -d\" -f4)
curl $ISO_URL > rhcos-live.x86_64.iso
mkdir ocp
cp install-config.yaml ocp
openshift-install --dir=ocp create single-node-ignition-config
alias coreos-installer='podman run --privileged --rm -v /dev:/dev -v /run/udev:/run/udev -v $PWD:/data -w /data quay.io/coreos/coreos-installer:release'
cp ocp/bootstrap-in-place-for-live-iso.ign iso.ign
coreos-installer iso ignition embed -fi iso.ign rhcos-live.x86_64.iso
yes | cp -f rhcos-live.x86_64.iso /tmp
echo lastcmd

###

virsh destroy okd4-snc-master ; virsh undefine okd4-snc-master ; rm -f /VirtualMachines/okd4-snc-master ; rm -f /tmp/rhcos-live.x86_64.iso


```

# 4.9
```
# do not use it
oc patch etcd cluster -p='{"spec": {"unsupportedConfigOverrides": {"useUnsupportedUnsafeNonHANonProductionUnstableEtcd": true}}}' --type=merge

# currently used it
oc patch IngressController default -n openshift-ingress-operator -p='{"spec": {"replicas": 1}}' --type=merge

# test to not applied 
oc patch authentications.operator.openshift.io cluster -p='{"spec": {"unsupportedConfigOverrides": {"useUnsupportedUnsafeNonHANonProductionUnstableOAuthServer": true }}}' --type=merge

```

## test upgrade
Cluster operator authentication should not be upgraded between minor versions: UnsupportedConfigOverridesUpgradeable: setting: [useUnsupportedUnsafeNonHANonProductionUnstableOAuthServer]

```
# not solved
oc patch clusterversion version --type="merge" -p '{"spec":{"channel":"stable-4.10"}}'  
```
