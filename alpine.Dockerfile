FROM ksponomarev/werf:latest as collector

FROM alpine
COPY --from=collector /usr/local/bin/ /usr/local/bin/
RUN apk add --no-cache curl wget bash; sed -i 's/\/bin\/ash/\/bin\/bash/g' /etc/passwd;
