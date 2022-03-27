
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

systemctl enable nginx --now
mkdir -p /usr/share/nginx/html/install/fcos/ignition
systemctl start nginx

ssh-keygen -t ed25519 -N "" -f /root/.ssh/id_ed25519

mkdir -p /root/okd4-snc
cd /root/okd4-snc
git clone -b new --single-branch git@github.com:nitramrc/okd4-single-node-cluster.git
cd okd4-single-node-cluster

mkdir ~/bin
cp ./bin/* ~/bin
chmod 750 ~/bin/*

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
echo ". /root/bin/setSncEnv.sh" >> ~/.bashrc
# . /root/bin/setSncEnv.sh


