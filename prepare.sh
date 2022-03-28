
cd $HOME


dnf -y module install virt
dnf -y install wget git net-tools bind bind-utils bash-completion rsync libguestfs-tools virt-install epel-release libvirt-devel httpd-tools nginx

systemctl enable libvirtd --now
mkdir /VirtualMachines
virsh pool-destroy default
virsh pool-undefine default
virsh pool-define-as --name default --type dir --target /VirtualMachines
virsh pool-autostart default
virsh pool-start default
systemctl start libvirtd

dnf -y groupinstall "Xfce" "base-x"
dnf -y install xrdp
systemctl start xrdp
dnf -y install virt-manager

systemctl enable nginx --now
mkdir -p /usr/share/nginx/html/install/fcos/ignition
systemctl start nginx

ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519

########## manual debug

mkdir -p /root/okd4-snc
cd /root/okd4-snc
git clone -b new --single-branch git@github.com:nitramrc/okd4-single-node-cluster.git
cd okd4-single-node-cluster

mkdir -p ~/bin
yes | cp -f ./bin/* ~/bin
chmod 750 ~/bin/*

##########

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
echo ". /root/bin/setSncEnv.sh" >> ~/.bashrc
. /root/bin/setSncEnv.sh

########## manual debug

/root/bin/setupDNS.sh

########## manual debug


cp ${OKD4_SNC_PATH}/okd4-single-node-cluster/install-config-snc.yaml ${OKD4_SNC_PATH}/install-config-snc.yaml
sed -i "s|%%SNC_DOMAIN%%|${SNC_DOMAIN}|g" ${OKD4_SNC_PATH}/install-config-snc.yaml
SSH_KEY=$(cat ~/.ssh/id_ed25519.pub)
sed -i "s|%%SSH_KEY%%|${SSH_KEY}|g" ${OKD4_SNC_PATH}/install-config-snc.yaml


cd ${OKD4_SNC_PATH}
wget https://github.com/openshift/okd/releases/download/${OKD_RELEASE}/openshift-client-linux-${OKD_RELEASE}.tar.gz
tar -xzf openshift-client-linux-${OKD_RELEASE}.tar.gz
mv oc ~/bin
mv kubectl ~/bin
rm -f openshift-client-linux-${OKD_RELEASE}.tar.gz
rm -f README.md

mkdir -p ${OKD4_SNC_PATH}/okd-release-tmp
cd ${OKD4_SNC_PATH}/okd-release-tmp
oc adm release extract --command='openshift-install' ${OKD_REGISTRY}:${OKD_RELEASE}
oc adm release extract --command='oc' ${OKD_REGISTRY}:${OKD_RELEASE}
mv -f openshift-install ~/bin
mv -f oc ~/bin
cd ..
rm -rf okd-release-tmp
