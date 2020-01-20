FROM ubuntu:xenial

RUN set -ex;\
    apt update -qq;\
    apt install curl apt-transport-https -y;\
    curl -L https://raw.githubusercontent.com/flant/multiwerf/master/get.sh | bash;\
    mv /multiwerf /usr/bin/multiwerf

RUN set -ex;\
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -;\
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list;\
    apt update -qq;\
    apt-get install -y kubectl apt-utils wget

RUN set -ex;\
    cd /tmp;\
    wget https://get.helm.sh/helm-v3.0.2-linux-amd64.tar.gz;\
    tar -zxvf helm-v3.0.2-linux-amd64.tar.gz;\
    mv linux-amd64/helm /usr/local/bin/helm
