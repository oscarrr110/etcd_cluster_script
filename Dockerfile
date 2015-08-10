FROM ubuntu:14.04
RUN apt-get install -y git
RUN apt-get install -y curl
COPY *.sh /tmp/
COPY etcd-v2.1.1-linux-amd64.tar.gz /tmp/
WORKDIR /tmp
RUN tar -xvf etcd-v2.1.1-linux-amd64.tar.gz
WORKDIR /tmp/etcd-v2.1.1-linux-amd64
ENV ETCD_BIN=/tmp/etcd-v2.1.1-linux-amd64/
ENV PATH=$PATH:/tmp/etcd-v2.1.1-linux-amd64/
#ENTRYPOINT ["etcd"]
