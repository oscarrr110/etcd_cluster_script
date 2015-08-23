#!/bin/sh
IP=`cat /etc/hosts | head -n 1 |awk '{print $1}'`

CMD="etcd -proxy on -listen-client-urls http://$IP:8080 -discovery $DISCOVERY_SERVICE"
echo $CMD >> /var/log/etcd_proxy.log
$CMD >> /var/log/etcd_proxy.log 2>&1

#while true; do
#   sleep 1
#done
