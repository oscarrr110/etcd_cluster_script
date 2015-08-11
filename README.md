# etcd_cluster_script

## usage
```
Format: start_etcd_cluster.sh <ROOT_PASSWORD> <NEW_USER_NAME> <NEW_USER_ROLE> <GRANT_PATH_DIR>
Example: start_etcd_cluster.sh  1111 tuhu 0810 test
```

## Details (start_etcd_cluster.sh),Star up script(start_etcd_cluster.sh), Include following step

### build the basic image ,  which is described as Dockerfile

Install necessary packages for etcd

Add etcd and auth related scripts

#### 2 get the discovery url 

Use Discovery way to setup etcd cluster, please refer to

[runtime]: runtime-configuration.md

It can also use local etcd service to discovery new node
