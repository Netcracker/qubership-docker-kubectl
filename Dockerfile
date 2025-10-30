FROM alpine:3.22

ENV HOME="/"

RUN set -x \
    && apk add --update --no-cache \
        curl \
        jq \
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
        "https://dl.k8s.io/v1.34.1/bin/linux/${TARGETARCH}/kubectl" \
    && chmod +x /usr/bin/kubectl

RUN set -eux \
  && cp /bin/busybox.static /bin/busybox \
  && chmod 0755 /bin/busybox

# Upgrade all tools to avoid vulnerabilities
RUN set -x && apk upgrade --no-cache --available

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/main" > /etc/apk/repositories  \
    && echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
    && apk add --update --upgrade --no-cache \
        curl libcurl jq

USER 1001
ENTRYPOINT [ "kubectl" ]
