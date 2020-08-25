FROM ubuntu:focal AS collector

ARG WERF=1.1
ARG WERF_VERSION=stable
ARG DOCKER=19.03.12

RUN apt update -qq;\
    apt install curl apt-transport-https git wget apt-utils gnupg2 zip unzip ca-certificates jq -y;

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl;\
    mv kubectl /usr/local/bin/;


RUN curl -L https://raw.githubusercontent.com/flant/multiwerf/master/get.sh | bash;\
    mv multiwerf /usr/local/bin/multiwerf;\
    type multiwerf && . $(multiwerf use ${WERF} ${WERF_VERSION} --as-file);

RUN HELM=$(curl -s https://api.github.com/repos/helm/helm/releases | jq -r '.[].tag_name' | grep v3| grep -v rc | head -1);\
    wget https://get.helm.sh/helm-${HELM}-linux-amd64.tar.gz;\
    tar -zxf helm-${HELM}-linux-amd64.tar.gz;\
    mv linux-amd64/helm /usr/local/bin/helm;

RUN wget https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKER}.tgz -O docker-${DOCKER}.tgz;\
    tar -xf docker-${DOCKER}.tgz;\
    mv docker/docker /usr/local/bin;

RUN curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash;\
    mv /root/yandex-cloud/bin/* /usr/local/bin/

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";\
    unzip awscliv2.zip; ./aws/install

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp;\
    mv /tmp/eksctl /usr/local/bin

RUN chmod +x /usr/local/bin/*

FROM ubuntu:focal
COPY --from=collector /usr/local/aws-cli /usr/local/aws-cli
COPY --from=collector /usr/local/bin/ /usr/local/bin/
RUN apt update -qq; apt install -y curl wget git; rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*
