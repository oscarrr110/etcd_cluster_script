#!/bin/sh

if [ "$#" -ne 4 ]; then
   echo "Usage: $0 <ROOT_PASSWORD> <NEW_USER_NAME> <NEW_USER_ROLE> <GRANT_PATH_DIR>" >&2
   exit 1
fi

echo "=============================1. Docker build basic image ==================================="

sudo docker build -t "etcd/base_image" .

echo "=============================2. Start curl discorvery url==================================="

URL=`curl https://discovery.etcd.io/new?size=3` 2>/dev/null
URL=$(echo $URL|sed 's/\W/\\&/g')
echo $URL
cp -f etcd-run-compose.yml.tml etcd-run-compose.yml
cmd="sed -i "s/\$DISCOVERY_SERVICE/"$URL"/g" etcd-run-compose.yml"
$cmd

echo "=============================3. Startup  all etcd services=================================="

sudo docker-compose -f etcd-run-compose.yml up -d
sleep 10

echo "=============================4. Grant all privileges========================================"

sudo docker exec -it `sudo docker ps -q |head -n 1`  /etcd/auth/etcd_user_init.sh $@

echo "=============================5. Test etcd cluster==========================================="
GRANT_PATH_DIR=$4
NEW_USER_NAME=$2


ENCODE_KEY=`echo -n $NEW_USER_NAME:$NEW_USER_NAME | base64`

echo "encode key: $ENCODE_KEY"

echo "=====5.1 Auth failed for put/get operation===="
CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XPUT -L http://127.0.0.1:2381/v2/keys/invalid_path/key -d value=1"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XPUT -L http://127.0.0.1:2381/v2/keys/invalid_path/key -d value=1` 2>/dev/null
echo $RESULT

CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XGET -L http://127.0.0.1:2381/v2/keys/invalid_path/key"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XGET -L http://127.0.0.1:2381/v2/keys/invalid_path/key` 2>/dev/null
echo $RESULT

echo "=====5.2 Auth success for put/get operation===="

CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XPUT -L http://127.0.0.1:2381/v2/keys/$GRANT_PATH_DIR/key -d value=1"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XPUT -L http://127.0.0.1:2381/v2/keys/$GRANT_PATH_DIR/key -d value=1` 2>/dev/null
echo $RESULT

CMD="curl -H 'Authorization: Basic $ENCODE_KEY' -XGET -L http://127.0.0.1:2381/v2/keys/$GRANT_PATH_DIR/key"
echo $CMD
RESULT=`curl -H "Authorization: Basic $ENCODE_KEY" -XGET -L http://127.0.0.1:2381/v2/keys/$GRANT_PATH_DIR/key` 2>/dev/null
echo $RESULT
