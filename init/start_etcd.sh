#!/bin/sh
IP=`cat /etc/hosts | head -n 1 |awk '{print $1}'`

CMD="etcd -name aliyun_container_`hostname` -initial-advertise-peer-urls http://$IP:2380 \
-listen-peer-urls http://$IP:2380 \
-listen-client-urls http://$IP:2379,http://127.0.0.1:2379 \
-advertise-client-urls http://$IP:2379 \
-initial-cluster-token etcd-cluster-1 \
-discovery $DISCOVERY_SERVICE"

echo $CMD >> /var/log/etcd.log
$CMD >> /var/log/etcd.log 2>&1

while true; do
   sleep 1
done
