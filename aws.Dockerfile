FROM ksponomarev/werf:latest as collector

RUN apt update -qq; apt install zip unzip -y

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip";\
    unzip awscliv2.zip; ./aws/install

RUN curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp;\
    mv /tmp/eksctl /usr/local/bin

RUN chmod +x /usr/local/bin/*

FROM ubuntu:bionic
COPY --from=collector /usr/local/bin/ /usr/local/bin/
COPY --from=collector /usr/local/aws-cli /usr/local/aws-cli
RUN apt update -qq; apt install -y curl wget; rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*
