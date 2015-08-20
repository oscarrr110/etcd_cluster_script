# etcd_cluster_script

## Usage
```
Format: start_etcd_cluster.sh <ROOT_PASSWORD> <NEW_USER_NAME> <NEW_USER_ROLE> <GRANT_PATH_DIR>
Example: start_etcd_cluster.sh  1111 tuhu 0810 test
```

## Start up etcd service, Include following step

### 1. Build the basic image ,  which is described as Dockerfile

Install necessary packages for etcd

Add etcd and auth related scripts

### 2. Get the discovery url 

Use Discovery way to setup etcd cluster, please refer to Etcd cluster document

It can also use local etcd service to discovery new node

### 3. Start up all etcd services

Based on the step 1 image, We startup every etcd node. export different port to the external use, and adding DISCOVERY_SERVICE env, which is produced by step 2

Start init files for start etcd service

Related files:  init/start_etcd.sh, etcd-run-compose.yml

### 4. Grant all privileges

Get any node in the etcd cluster and execute etc_user_init.sh script, Mainly function is : create User, Role, Path and granted related permission

Related files: auth/etcd_user_init.sh , auth/grant.expect

### 5. Simple test

Auth failed for put/get operation while using unauthorized paths

Auth success for put/get operation while using authorized paths

## Next work

#### Add etcd proxy node for the specified etcd cluster

#### Signed Cert auth way can be considered , currently it only support basic way(username:password)

#### It still have some bugs using the basic auth, while client get key value in the http way

##### 1)If one path has been granted to the role , it does not add any http header(Authorization: Basic {encoded string}), It can still get the key successful

##### 2)If one path has been granted to the role , It add the wrong encoded string, It can still get the key successful