

. /root/bin/setSncEnv.sh


PRIMARY_NIC="eth0"

nmcli connection add type bridge ifname br0 con-name br0 ipv4.method manual ipv4.address "${SNC_HOST}/19" ipv4.gateway "${SNC_GATEWAY}" ipv4.dns "${SNC_NAMESERVER}" ipv4.dns-search "${SNC_DOMAIN}" ipv4.never-default no connection.autoconnect yes bridge.stp no ipv6.method ignore

nmcli con add type ethernet con-name br0-bind-1 ifname ${PRIMARY_NIC} master br0

nmcli con del ${PRIMARY_NIC}

nmcli con add type ethernet con-name ${PRIMARY_NIC} ifname ${PRIMARY_NIC} connection.autoconnect no ipv4.method disabled ipv6.method ignore

systemctl restart NetworkManager.service


