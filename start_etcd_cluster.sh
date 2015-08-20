#!/bin/bash

if [ "$#" -ne 5 ]; then
   echo "Usage: $0 <ROOT_PASSWORD> <NEW_USER_NAME> <NEW_USER_ROLE> <GRANT_PATH_DIR> <OS: MAC/LINUX>" >&2
   exit 1
fi


OS=$5

echo "=============================1. Docker build/clean image ==================================="

if [ "MAC"  != "$OS" ]; then
	docker build -t "etcd/base_image" .
else
	docker rm -f `docker ps -a |grep etcd | awk '{print $1}'`
fi
echo "=============================2. Start curl discorvery url==================================="

URL=`curl https://discovery.etcd.io/new?size=3` 2>/dev/null
URL=$(echo $URL|sed 's/\W/\\&/g')
echo $URL
cp -f etcd-run-compose.yml.tml etcd-run-compose.yml

if [ "MAC"  == "$OS" ]; then
	#for mac
	cmd="sed -i .bak s#\$DISCOVERY_SERVICE#$URL#g etcd-run-compose.yml"
else
	#for linux
	cmd="sed -i "s/\$DISCOVERY_SERVICE/"$URL"/g" etcd-run-compose.yml"
fi	
$cmd

echo "=============================3. Startup  all etcd services=================================="

docker-compose -f etcd-run-compose.yml up -d
sleep 20

echo "=============================4. Grant all privileges========================================"

docker exec -it `docker ps -q |head -n 1`  /etcd/auth/etcd_user_init.sh $1 $2 $3 $4

echo "=============================5. Test etcd cluster==========================================="
GRANT_PATH_DIR=$4
NEW_USER_NAME=$2


ENCODE_KEY=`echo -n $NEW_USER_NAME:$NEW_USER_NAME | base64`
echo "encode key: $ENCODE_KEY"

if [ "MAC"  == "$OS" ]; then
	SERVICE_IP=`boot2docker ip`
else
	SERVICE_IP=127.0.0.1
fi

echo "=====5.1 Auth failed for put/get operation===="
CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XPUT -L http://$SERVICE_IP:2381/v2/keys/invalid_path/key -d value=1"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XPUT -L http://$SERVICE_IP:2381/v2/keys/invalid_path/key -d value=1` 2>/dev/null
echo $RESULT

CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XGET -L http://$SERVICE_IP:2381/v2/keys/invalid_path/key"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XGET -L http://$SERVICE_IP:2381/v2/keys/invalid_path/key` 2>/dev/null
echo $RESULT

echo "=====5.2 Auth success for put/get operation===="

CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XPUT -L http://$SERVICE_IP:2381/v2/keys/$GRANT_PATH_DIR/key -d value=1"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XPUT -L http://$SERVICE_IP:2381/v2/keys/$GRANT_PATH_DIR/key -d value=1` 2>/dev/null
echo $RESULT

CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XGET -L http://$SERVICE_IP:2381/v2/keys/$GRANT_PATH_DIR/key"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XGET -L http://$SERVICE_IP:2381/v2/keys/$GRANT_PATH_DIR/key` 2>/dev/null
echo $RESULT
