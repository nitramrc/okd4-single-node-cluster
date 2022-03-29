export SNC_DOMAIN=snc.test
export SNC_HOST=192.168.122.1
export SNC_NAMESERVER=${SNC_HOST}
export SNC_NETMASK=255.255.255.0
export SNC_GATEWAY=192.168.122.1
export MASTER_HOST=192.168.122.150
export BOOTSTRAP_HOST=192.168.122.149
export SNC_NETWORK=192.168.122.0/24
export INSTALL_HOST_IP=${SNC_HOST}
export INSTALL_ROOT=/usr/share/nginx/html/install
export INSTALL_URL=http://${SNC_HOST}/install
export OKD4_SNC_PATH=/root/okd4-snc
export OKD_REGISTRY=quay.io/openshift/okd
export OKD_RELEASE=4.8.0-0.okd-2021-11-14-052418
# export OKD_RELEASE=4.9.0-0.okd-2022-02-12-140851
# export OKD_RELEASE=4.10.0-0.okd-2022-03-07-131213
