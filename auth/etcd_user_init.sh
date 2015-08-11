#!/bin/bash

function init_user_and_password() {   
    CURRENT=`dirname $0`
    $CURRENT/grant.expect root $ROOT_PASSWORD
    etcdctl -u root:$ROOT_PASSWORD auth enable
    etcdctl -u root:$ROOT_PASSWORD role add $NEW_USER_ROLE
    $CURRENT/grant.expect $NEW_USER_NAME $NEW_USER_NAME $ROOT_PASSWORD
    etcdctl -u root:$ROOT_PASSWORD user grant $NEW_USER_NAME -roles $NEW_USER_ROLE
    #etcdctl -u root:$ROOT_PASSWORD role grant $NEW_USER_ROLE  -path '/\$GRANT_PATH_DIR/*' -readwrite
    etcdctl -u root:$ROOT_PASSWORD role grant $NEW_USER_ROLE  -path /$GRANT_PATH_DIR/* -readwrite
}

function cleanup() {
    etcdctl role revoke $NEW_USER_ROLE -path '/\$GRANT_PATH_DIR/*' -readwrite
    etcdctl -u root:$ROOT_PASSWORD user remove $NEW_USER_NAME
    etcdctl -u root:$ROOT_PASSWORD role remove $NEW_USER_ROLE
    etcdctl -u root:$ROOT_PASSWORD auth disable
    etcdctl -u root:$ROOT_PASSWORD user remove root
}

if [ "$#" -ne 4 ]; then
   echo "Usage: $0 <ROOT_PASSWORD> <NEW_USER_NAME> <NEW_USER_ROLE> <GRANT_PATH_DIR>" >&2
   exit 1
fi

ROOT_PASSWORD=$1
NEW_USER_NAME=$2
NEW_USER_ROLE=$3
GRANT_PATH_DIR=$4
echo "===========================Argument List=============================="
echo "ROOT_PASSWORD: $ROOT_PASSWORD"
echo "NEW_USER_NAME: $NEW_USER_NAME"
echo "NEW_USER_ROLE: $NEW_USER_ROLE"
echo "GRANT_PATH_DIR: $GRANT_PATH_DIR"
echo "======================================================================"

echo "===========================Cleanup Env================================"
cleanup
echo "======================================================================"

echo "=========================Init User and Role==========================="
init_user_and_password
echo "======================================================================"
