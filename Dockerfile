FROM alpine:3.24

ENV HOME="/"

RUN set -x \
    && apk add --update --no-cache \
        bash \
        busybox-static \
    && rm -rf /var/cache/apk/*

ARG TARGETARCH

#Download necessary tools
RUN set -x \
    && wget \
        --no-check-certificate \
        -nv \
        -O /usr/bin/kubectl \
        "https://dl.k8s.io/v1.36.1/bin/linux/${TARGETARCH}/kubectl" \
    && chmod +x /usr/bin/kubectl

RUN set -eux \
  && cp /bin/busybox.static /bin/busybox \
  && chmod 0755 /bin/busybox

# Upgrade all tools to avoid vulnerabilities
RUN set -x && apk upgrade --no-cache --available

RUN apk add --update --upgrade --no-cache \
        curl libcurl jq libcrypto3 libssl3

USER 1001
ENTRYPOINT [ "kubectl" ]
