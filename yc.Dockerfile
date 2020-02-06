FROM alpine:latest

ENV HELM_VERSION=v3.0.2
ENV KUBECTL_VERSION=v1.17.0

RUN set -ex;\
    apk add curl git bash;\
    sed -i 's/ash/bash/g' /etc/passwd;\
    cd /tmp;\
    curl -L https://raw.githubusercontent.com/flant/multiwerf/master/get.sh | sh;\
    mv /tmp/multiwerf /usr/bin/multiwerf;\
    wget https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz;\
    tar -zxvf helm-${HELM_VERSION}-linux-amd64.tar.gz;\
    mv linux-amd64/helm /usr/local/bin/helm;\
    curl -LO https://storage.googleapis.com/kubernetes-release/release/${KUBECTL_VERSION}/bin/linux/amd64/kubectl;\
    mv ./kubectl /usr/local/bin/kubectl;\
    chmod +x /usr/local/bin/kubectl;\
    type multiwerf;\
    . $(multiwerf use 1.0 stable --as-file);\
    curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash;\
    mv /root/yandex-cloud/bin/yc /usr/bin/;\
    rm -Rf /tmp/* /root/yandex-cloud/bin/yc