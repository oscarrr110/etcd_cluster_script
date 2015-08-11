# etcd_cluster_script

## Usage
```
Format: start_etcd_cluster.sh <ROOT_PASSWORD> <NEW_USER_NAME> <NEW_USER_ROLE> <GRANT_PATH_DIR>
Example: start_etcd_cluster.sh  1111 tuhu 0810 test
```

## Star up etcd service, Include following step

### Build the basic image ,  which is described as Dockerfile

Install necessary packages for etcd

Add etcd and auth related scripts

#### get the discovery url 

Use Discovery way to setup etcd cluster, please refer to 

It can also use local etcd service to discovery new node
