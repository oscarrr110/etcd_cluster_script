#!/bin/sh
export REGISTRY=10.32.161.160:5000/
docker build -t ${REGISTRY}etcd/base_image .
docker push ${REGISTRY}etcd/base_image
