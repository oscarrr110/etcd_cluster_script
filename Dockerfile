FROM ubuntu:14.04
#FROM quay.io/coreos/etcd:v2.0.10
RUN apt-get install -y \
    expect \
    git \
    curl
#WORKDIR /tmp
#RUN curl -L  https://github.com/coreos/etcd/releases/download/v2.1.1/etcd-v2.1.1-linux-amd64.tar.gz -o etcd-v2.1.1-linux-amd64.tar.gz
#ADD  https://github.com/coreos/etcd/releases/download/v2.1.1/etcd-v2.1.1-linux-amd64.tar.gz /etcd/
COPY etcd-v2.1.1-linux-amd64.tar.gz /etcd/
ADD  auth /etcd/auth
ADD  init /etcd/init
WORKDIR /etcd/
RUN tar -xvf etcd-v2.1.1-linux-amd64.tar.gz
WORKDIR /etcd/etcd-v2.1.1-linux-amd64
ENV ETCD_BIN=/etcd/etcd-v2.1.1-linux-amd64/
ENV PATH=$PATH:/etcd/etcd-v2.1.1-linux-amd64/
