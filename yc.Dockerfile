FROM ksponomarev/werf:latest as collector

RUN curl https://storage.yandexcloud.net/yandexcloud-yc/install.sh | bash;\
    mv /root/yandex-cloud/bin/* /usr/local/bin/

RUN chmod +x /usr/local/bin/*

FROM ubuntu:bionic
COPY --from=collector /usr/local/bin/ /usr/local/bin/
RUN apt update -qq; apt install -y curl wget git; rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*
