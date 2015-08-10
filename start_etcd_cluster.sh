#!/bin/sh

URL=`curl https://discovery.etcd.io/new?size=3`
URL=$(echo $URL|sed 's/\W/\\&/g')
echo $URL
cp -f etcd-run-compose.yml.tml etcd-run-compose.yml
cmd="sed -i "s/\$DISCOVERY_SERVICE/"$URL"/g" etcd-run-compose.yml"
$cmd

sudo docker-compose -f etcd-run-compose.yml up -d
