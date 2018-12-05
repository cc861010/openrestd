FROM golang:1.9-alpine as confd

ARG CONFD_VERSION=0.16.0

ADD https://github.com/kelseyhightower/confd/archive/v${CONFD_VERSION}.tar.gz /tmp/

RUN apk add --no-cache \
    bzip2 \
    make && \
  mkdir -p /go/src/github.com/kelseyhightower/confd && \
  cd /go/src/github.com/kelseyhightower/confd && \
  tar --strip-components=1 -zxf /tmp/v${CONFD_VERSION}.tar.gz && \
  go install github.com/kelseyhightower/confd && \
  rm -rf /tmp/v${CONFD_VERSION}.tar.gz

FROM openresty/openresty:1.13.6.2-2-alpine

COPY --from=confd /go/bin/confd /usr/local/bin/confd

RUN apk update \
    && apk add tzdata \
    && ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shanghai" > /etc/timezone
