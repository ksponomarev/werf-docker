FROM ksponomarev/werf:latest as collector

FROM google/cloud-sdk:slim
COPY --from=collector /usr/local/bin/ /usr/local/bin/
RUN apt update -qq; apt install -y curl wget git; rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*
