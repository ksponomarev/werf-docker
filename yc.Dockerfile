FROM ubuntu:bionic AS collector

ARG HELM=v3.1.0
ARG WERF=1.1
ARG WERF_VERSION=ea
ARG DOCKER=19.03.8

RUN apt update -qq;\
    apt install curl apt-transport-https git -y wget apt-utils gnupg2 zip unzip ca-certificates;

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;\
    mv kubectl /usr/local/bin/;


RUN curl -L https://raw.githubusercontent.com/flant/multiwerf/master/get.sh | bash;\
    mv multiwerf /usr/local/bin/multiwerf;\
    type multiwerf && . $(multiwerf use ${WERF} ${WERF_VERSION} --as-file);

RUN wget https://get.helm.sh/helm-${HELM}-linux-amd64.tar.gz;\
    tar -zxf helm-${HELM}-linux-amd64.tar.gz;\
    mv linux-amd64/helm /usr/local/bin/helm;

RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER}.tgz -O docker-${DOCKER}.tgz;\
    tar -xf docker-${DOCKER}.tgz;\
    mv docker/docker /usr/local/bin;

RUN curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash;\
    mv /root/yandex-cloud/bin/* /usr/local/bin/

RUN chmod +x /usr/local/bin/*

FROM ubuntu:bionic
COPY --from=collector /usr/local/bin/ /usr/local/bin/
RUN apt update -qq; apt install -y curl wget; rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*
